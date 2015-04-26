class Player
  constructor: (
    @playerType
    @color
    controlScheme
    @direction= -1
  ) ->

    @x= 0
    @y= 0
    @width= 7
    @height= 12
    @xForce= 1.7
    @yForce= 2

    @spawn= undefined
    @item= undefined
    @cache= {}
    @subEntities = {}

    @vel=
      x: 0
      y: 0
      mod:
        gravity:
          x: 0
          y: 0

    pause: false

    @effects= {}

    @item = undefined

    @invincibleTimeout = ->

    # On Build Event
    @onBuild = (level) ->
      @other = players[if playerType is 'red' then 'blue' else 'red']
      @maxLives = 10
      @lives = @maxLives - 3

    playerType = @playerType
    player = @

    # Player Keys
    @keys = {}
    @keys[controlScheme.up] =
      press: ->
        addPlayerVelocity playerType, 'up', {
          y: -player.yForce
        }
        # fight against the punch
        if player.vel.mod.punch_down?
          player.vel.mod.punch_down.y -= player.yForce / 8

        player.vel.mod.gravity.y = 0
        sound.play('flap')
    @keys[controlScheme.down] =
        press: ->
          removePlayerVelocity playerType, 'up'
    @keys[controlScheme.left] =
        press: ->
          player.direction = -1
          addPlayerVelocity playerType, 'left', {
            x: -player.xForce
          }

          # fight against the punch
          if player.vel.mod.punch_left?.x
            player.vel.mod.punch_left.x -= player.xForce / 4

        release: ->
          removePlayerVelocity playerType, 'left'
    @keys[controlScheme.right] =
        press: ->
          player.direction = 1
          addPlayerVelocity playerType, 'right', {
            x: player.xForce
          }

          # fight against the punch
          if player.vel.mod.punch_right?.x
            player.vel.mod.punch_right.x += player.xForce / 4

        release: ->
          removePlayerVelocity playerType, 'right'
    @keys[controlScheme.item] =
        press: ->
          player.useItem()

  type: 'Player'

  isSolidTo: -> true

  useItem: ->
    @item?.use()

  removeAllEffects: ->
    for name, effect of @effects
      @removeEffect name
  removeEffect: (name) ->
    if @effects[name]?
      @effects[name].timeout()
      @effects[name].remove()
      @effects[name] = undefined
      delete @effects[name]
  addEffect: (name, add, remove, time) ->
    # if perk isn't running, add effect again
    @effects[name]?.timeout()
    remove()
    add()
    
    @effects[name] = 
      remove: remove
      timeout: setFrameTimeout =>
        # run perk removal function
        remove()
        # remove perk
        @effects[name] = undefined
        delete @effects[name]
      , time

  onHit: (c, e, solid) =>
    if solid
      

      if c.top
        @vel.mod.up?.y = 0


      if c.bottom
        @vel.mod.gravity.y = 0
        @vel.mod.punch_down?.y = 0
        if !@keys.w?.pressed
          removePlayerVelocity @playerType, 'up'


      if c.bottom or c.top
        # apply friction to punch slides
        if @vel.mod.punch_right?
          if @vel.mod.punch_right?.x
            @vel.mod.punch_right.x += 0.05
        if @vel.mod.punch_left?
          if @vel.mod.punch_left?.x
            @vel.mod.punch_left.x -= 0.05

      if c.left
        removePlayerVelocity @playerType, 'punch_right'
      if c.right
        removePlayerVelocity @playerType, 'punch_left'

      if e.type is 'Player' and !e.invincible
        if @vel.y > 1 and c.bottom
          sound.play('pop')
          addPlayerVelocity e.playerType, 'punch_down', {
            y: @vel.y
          }

        else if @vel.x > 1 and c.right
          sound.play('pop')
          addPlayerVelocity e.playerType, 'punch_left', {
            x: @vel.x
          }
          removePlayerVelocity @playerType, 'right'

        else if @vel.x < -1 and c.left
          sound.play('pop')
          addPlayerVelocity e.playerType, 'punch_right', {
            x: @vel.x
          }
          removePlayerVelocity @playerType, 'left'


          # e.die()


  update: ->
    if !@pause

      # add gravity
      @vel.mod.gravity.y += gravity

      @vel.x = 0
      @vel.y = 0

      # clean up punch velocities
      if @vel.mod.punch_right?.x > 0
        removePlayerVelocity @playerType, 'punch_right'
      if @vel.mod.punch_left?.x < 0
        removePlayerVelocity @playerType, 'punch_left'
      if @vel.mod.punch_down?.y < 0
        removePlayerVelocity @playerType, 'punch_down'



      for name, mod of @vel.mod
        if mod.x then @vel.x += mod.x
        if mod.y then @vel.y += mod.y

      for name, subEnt of @subEntities
        subEnt.update?()

    applyPhysics @

  die: (before, after) ->
    if !@invincible
      before?()

      level?.addBlinkUpdate @spawn.x + @spawn.width / 2, @spawn.y, '-1', true

      @removeAllEffects()

      @lives--
      @vel = 
        x: 0
        y: 0
        mod:
          gravity:
            x: 0
            y: 0
      @spawn.reset()

      after?()


  draw: (ctx, delta, time) ->
    if level?

      ctx
      .save()

      # draw the body
      .fillStyle(colors.playerFlesh)
      .fillRect(Math.round(@x),Math.round(@y), @width,@height)

      # draw the headband
      .fillStyle(@color)
      # .fillRect(Math.round(@x),Math.round(@y + 1), @width,1)

      # draw the pants
      .fillRect(Math.round(@x),Math.round(@y + 8), @width, 2)
      .fillRect(Math.round(@x + 2 + (1 * @direction)),Math.round(@y + 10), 3, 2)

      if @item?
        if @item.draw?
          @item.draw ctx
        else
          ctx
          .fillStyle(@item.color)
          .fillRect(Math.round(@x+@width/2-2),Math.round(@y+@height/2-2), 4,4)

      for name, subEnt of @subEntities
        subEnt.draw?(ctx, delta, time)



      ctx.restore()

      if @invincible
        ctx
        .save()
        .globalAlpha(0.5)
        .fillStyle(colors.invincible)
        .fillRect(
          Math.round(@x - 1)
          Math.round(@y - 1)
          @width + 2
          @height + 2
        )
        .restore()
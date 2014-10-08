class Player
  constructor: (
    playerType
    @color
    controlScheme
  ) ->

    @x= 0
    @y= 0
    @width= 7
    @height= 12
    @xForce= 1.7
    @yForce= 2

    @direction= -1

    @spawn= undefined
    @item= undefined
    @cache= {}

    @vel=
      x: 0
      y: 0
      mod:
        gravity:
          x: 0
          y: 0

    pause: false

    @playerType = playerType

    @effects= {}

    @invincibleTimeout = ->

    # On Build Event
    @onBuild = (level) ->
      @other = players[if playerType is 'alien' then 'human' else 'alien']
      @maxLives = 5
      @lives = @maxLives

    # Player Keys
    @keys = {}
    @keys[controlScheme.up] =
      press: ->
        addPlayerVelocity playerType, 'up', {
          y: -players[playerType].yForce
        }
        players[playerType].vel.mod.gravity.y = 0
    #   release: ->
    #     removePlayerVelocity playerType, 'up'
    @keys[controlScheme.down] =
        press: ->
          removePlayerVelocity playerType, 'up'
      #     addPlayerVelocity playerType, 'down', {
      #       y: players[playerType].yForce
      #     }
      #     players[playerType].vel.mod.gravity.y = 0
        # release: ->
        #   removePlayerVelocity playerType, 'down'
    @keys[controlScheme.left] =
        press: ->
          players[playerType].direction = -1
          addPlayerVelocity playerType, 'left', {
            x: -players[playerType].xForce
          }
        release: ->
          removePlayerVelocity playerType, 'left'
    @keys[controlScheme.right] =
        press: ->
          players[playerType].direction = 1
          addPlayerVelocity playerType, 'right', {
            x: players[playerType].xForce
          }
        release: ->
          removePlayerVelocity playerType, 'right'
    @keys[controlScheme.item] =
        press: ->
          players[playerType].useItem()

  type: 'Player'

  isSolidTo: -> true

  useItem: ->
    @item?.use()

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
        if !@keys.w?.pressed
          removePlayerVelocity @playerType, 'up'
        if e.type is 'Player'
          e.die()

  update: ->
    if !@pause

      # add gravity
      @vel.mod.gravity.y += gravity

      @vel.x = 0
      @vel.y = 0

      for name, mod of @vel.mod
        if mod.x then @vel.x += mod.x
        if mod.y then @vel.y += mod.y

    applyPhysics @

  die: (before, after) ->
    if !@invincible
      before?()

      level?.addBlinkUpdate @x, @y, '-1', true

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


      if @invincible
        ctx
        .save()
        .globalAlpha(0.5)
        .strokeStyle(@color)
        .lineWidth(2)
        .strokeRect(Math.round(@x),Math.round(@y), @width,@height)
        .restore()


      ctx
      .save()
      .fillStyle(@color)
      .fillRect(Math.round(@x),Math.round(@y), @width,@height)

      if @item?
        if @item.draw?
          @item.draw ctx
        else
          ctx
          .fillStyle(@item.color)
          .fillRect(Math.round(@x+@width/2-2),Math.round(@y+@height/2-2), 4,4)

      ctx
      .fillStyle('red')
      .fillRect(
        Math.round((@x+@width/2) - 1 + (if @direction > 0 then +2 else -2))
        Math.round(@y+@height/2 - 1)
        2,2
      )
      .restore()
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

    # On Build Event
    @onBuild = (level) ->
      @other = players[if playerType is 'alien' then 'human' else 'alien']
      @maxLives = 5
      @lives = @maxLives
      @score = 0

    # Player Events
    @events =
      top_col: (ent) ->
        if ent.solid or ent.isSolidTo?(players[playerType])
          players[playerType].vel.mod.up.y = 0
      bottom_col: (ent) ->
        if ent.solid or ent.isSolidTo?(players[playerType])
          players[playerType].vel.mod.gravity.y = 0
          if !players[playerType].keys.w?.pressed
            removePlayerVelocity playerType, 'up'
        if ent.type is 'Player'
          ent.die()
      left_col: ->
      right_col: ->

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
          addPlayerVelocity playerType, 'left', {
            x: -players[playerType].xForce
          }
        release: ->
          removePlayerVelocity playerType, 'left'
    @keys[controlScheme.right] =
        press: ->
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

  die: ->
    if @spawn?.closed
      @lives--
      @vel = 
        x: 0
        y: 0
        mod:
          gravity:
            x: 0
            y: 0
      @spawn.reset()


  draw: (ctx, delta, time) ->
    if level?


      if not @spawn.closed
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
      ctx.restore()
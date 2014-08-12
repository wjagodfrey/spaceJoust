class Player
  constructor: (
    playerType
    @color
    controlScheme
  ) ->


    @solid= true
    @x= 0
    @y= 0
    @width=  7
    @height=  12
    @xForce=  1.7
    @yForce=  2

    @spawn= undefined

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
      @lives = 5

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
          console.log ent
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
          console.log playerType
          addPlayerVelocity playerType, 'right', {
            x: players[playerType].xForce
          }
        release: ->
          removePlayerVelocity playerType, 'right'

  type: 'Player'

  removeEffect: (name) ->
    if @effects[name]?
      clearTimeout @effects[name].timeout
      @effects[name].remove()
      @effects[name] = undefined
      delete @effects[name]
  addEffect: (name, add, remove, time) ->
    # if perk isn't running, add effect again
    if !@effects[name]
      add()
    else
      clearTimeout @effects[name].timeout
    @effects[name] = 
      remove: remove
      timeout: setTimeout =>
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

    playerHitsAndVelocity @

  die: ->
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
      ctx
      .save()
      .fillStyle(@color)
      .fillRect(Math.round(@x),Math.round(@y), @width,@height)
      .restore()
class entity.SuddenDeath
  constructor: (@level, @height = 0) ->

    @solid = true

    @type = 'SuddenDeath'

    @x = 0
    @y = 0
    @width = @level.width
    # @height = 0

    @grow = false
    @timeout = setTimeout =>
      @startGrowth()
    , 0

  vel:
    x: 0
    y: 0

  speed: 0.01

  startGrowth: ->
    @grow = true
  stopGrowth: ->
    clearTimeout @timeout
    @grow = false
    @height -= (@speed + 3)
    @y = level.height - @height
    applyPhysics @

  update: ->
    if @grow
      @height += @speed
      @y = level.height - @height + 1
      applyPhysics @

    if @height >= level.height/2
      @stopGrowth()

  onHit: (col, ent) ->
    destroyed = false
    if ent.type is 'Player'
      ent.die()
      destroyed = true
    else if ent.type is 'Bomb'
      ent.boom()
      destroyed = true
    else if ent.type is 'Item'
      ent.destroy()
      destroyed = true
    else if ent.type is 'Spawn'
      @stopGrowth()


    if destroyed
      true # animate object burning up


  draw: (ctx) ->
    ctx
    .save()
    # .globalAlpha(0.9)
    .fillStyle('orange')
    .fillRect(Math.round(@x), Math.round(@y), @width, @height)
    .restore()
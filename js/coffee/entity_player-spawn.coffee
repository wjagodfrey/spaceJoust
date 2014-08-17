class PlayerSpawn
  constructor: (@x, @y, playerType) ->

    @player = players[playerType.toLowerCase()]

    @solid = false
    @width = 20
    @height = 35

    @player?.spawn = @

    @type = 'Spawn'

  lockoutCount: 30

  isSolidTo: (item) ->
    (@type is 'Spawn' and (@player.playerType isnt item.playerType or @closed))

  onBuild: (level) ->
    @reset()

  reset: ->
    @closed = false
    @hitCount = 0
    @updateCount = 0

    @player?.x = @x + @.width/2 - @.player?.width/2
    @player?.y = @y + @.height/2 - @.player?.height/2

  update: ->
    if !@closed # then check to see if it should be closed
      @updateCount++
      if @updateCount - @hitCount > @lockoutCount
        @closed = true

  onHit: (col, ent) ->
    if ent.playerType is @player.playerType and !@closed
      if @hitCount isnt @updateCount
        @hitCount = 0
        @updateCount = 0
      @hitCount++

  draw: (ctx) ->
    ctx
    .save()
    .globalAlpha(if @closed then 0.8 else 0.2)
    .fillStyle(@player.color)
    .fillRect(Math.round(@x), Math.round(@y), @width, @height)
    .restore()
    .save()
    .fillStyle('white')
    .textAlign('left')
    .textBaseline('middle')
    .wrappedText(@player.lives.toString(), Math.round(@x)+7, Math.round(@y)+@height/2, @width)
    .restore()
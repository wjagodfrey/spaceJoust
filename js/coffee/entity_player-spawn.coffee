class PlayerSpawn
  constructor: (@x, @y, playerType) ->

    @player = players[playerType.toLowerCase()]

    @solid = false
    @width = 20
    @height = 20

    @player?.spawn = @

    @type = 'Spawn'

  isSolidTo: (item) ->
    (@type is 'Spawn' and @player.playerType isnt item.playerType)

  onBuild: (level) ->
    @reset()

  reset: ->
    @player?.x = @x + @.width/2 - @.player?.width/2
    @player?.y = @y + @.height/2 - @.player?.height/2

  draw: (ctx) ->
    ctx
    .save()
    .globalAlpha(0.5)
    .fillStyle(@player.color)
    .fillRect(Math.round(@x), Math.round(@y), @width, @height)
    .fillStyle('white')
    .textAlign('left')
    .textBaseline('middle')
    .wrappedText(@player.lives.toString(), Math.round(@x)+7, Math.round(@y)+@height/2, @width)
    .restore()
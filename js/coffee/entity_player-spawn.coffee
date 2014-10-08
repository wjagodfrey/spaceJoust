class entity.PlayerSpawn
  constructor: (@x, @y, playerType) ->

    @player = players[playerType.toLowerCase()]

    @width = 20
    @height = 35

    @player?.spawn = @

    @type = 'Spawn'

  lockoutCount: 30

  isSolidTo: (ent) ->
    false

  onBuild: (level) ->
    @reset()

  reset: ->
    @player?.x = @x + @.width/2 - @.player?.width/2
    @player?.y = @y + @.height/2 - @.player?.height/2

    @player.invincible = true
    @player.invincibleTimeout = setFrameTimeout =>
      @player.invincible = false
    , 1000

  draw: (ctx) ->
    ctx
    .save()
    .globalAlpha(0.2)
    .fillStyle(@player.color)
    .fillRect(Math.round(@x), Math.round(@y), @width, @height)
    .restore()

    barHeight = @height / @player.maxLives - 2
    lifeCount = 0
    while lifeCount++ < @player.lives
      ctx
      .save()

      .globalAlpha(0.2)
      .fillStyle('white')
      .fillRect(
        Math.round(@x)
        Math.round(
          (@y + @height) + 1 -
          ((barHeight + 2) * lifeCount)
        )
        @width
        barHeight
      )

      .restore()
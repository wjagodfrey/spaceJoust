class items.NoWingsEnemy
  constructor: (@container, @key, @spawner) ->
    console.log @container, @key

  type : 'Item'

  x : 0
  y : 0

  solid : false
  width : 5
  height : 5

  onHit: (col, ent) ->
    if ent.type is 'Player'

      player = ent.other

      # cache modified values
      cache =
        yForce: player.yForce

      player.addEffect(
        'NoWingsEnemy'
        -> # apply effect
          player.yForce = 0
          removePlayerVelocity player.playerType, 'up'
        -> # remove effect
          player.yForce = cache.yForce
        4000
      )

      # remove item
      @spawner?.itemCount--
      @container?[@key] = undefined
      delete @container?[@key]

  onBuild: (level) ->

  draw: (ctx) ->
    ctx
    .save()
    .globalAlpha(0.5)
    .fillStyle('#8aff58')
    .fillRect(Math.round(@x), Math.round(@y), @width, @height)
    .restore()
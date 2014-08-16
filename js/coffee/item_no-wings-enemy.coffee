class items.NoWingsEnemy
  constructor: (@container, @key, @spawner) ->

  type : 'Item'

  x : 0
  y : 0

  solid : false
  width : 5
  height : 5

  onHit: (col, ent) ->
    if ent.type is 'Player'

      player = ent.other

      player.addEffect(
        'NoWingsEnemy'
        -> # apply effect
          if !player.cache.noWingsEnemy?
            player.cache.noWingsEnemy =
              yForce: player.yForce
            player.yForce = 0
            removePlayerVelocity player.playerType, 'up'
        -> # remove effect
          if player.cache.noWingsEnemy?
            player.yForce = player.cache.noWingsEnemy.yForce
            delete player.cache.noWingsEnemy
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
    .fillStyle('#8aff58')
    .fillRect(Math.round(@x), Math.round(@y), @width, @height)
    .restore()
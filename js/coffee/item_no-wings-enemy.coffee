class item.NoWingsEnemy extends Item
  constructor: (@container, @key, @spawner) ->

  color : '#8aff58'

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
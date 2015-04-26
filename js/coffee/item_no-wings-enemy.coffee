class item.NoWingsEnemy extends Item
  constructor: (@container, @key, @spawner) ->

  color : colors.noWingsEnemy

  applyToOpponent: true

  applyItem: (player) ->
    player.addEffect(
      'NoWingsEnemy'
      -> # apply effect
        if !player.cache.noWingsEnemy?
          player.cache.noWingsEnemy =
            yForce: player.yForce
          player.yForce = 0
          removePlayerVelocity player.playerType, 'up'

          player.subEntities.noWingsEnemy ?=
            color: colors.noWingsEnemy
            alpha: 0.5
            margin: 2
            update: ->
            draw: (ctx) ->
              ctx
              .save()
              .fillStyle(@color)
              .globalAlpha(@alpha)
              .fillRect(
                Math.round(player.x - @margin)
                Math.round(player.y - @margin)
                player.width + @margin * 2
                player.height + @margin * 2
              )
              .restore()

      -> # remove effect
        if player.cache.noWingsEnemy?
          player.yForce = player.cache.noWingsEnemy.yForce
          delete player.cache.noWingsEnemy
          delete player.subEntities.noWingsEnemy
      4000
    )
class item.AddLife extends Item
  constructor: (@container, @key, @spawner) ->

  color: colors.life

  flyToSpawn: true

  onHit: (col, ent) ->
    if ent.type is 'Player' and ent.lives isnt ent.maxLives
      super(col, ent)

  applyItem: (player) ->
    player.lives++
    level?.addBlinkUpdate player.spawn.x + player.spawn.width / 2, player.spawn.y, '+1', false
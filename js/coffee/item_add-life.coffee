class item.AddLife extends Item
  constructor: (@container, @key, @spawner) ->

  color: '#cb71ff'

  onHit: (col, ent) ->
    if ent.type is 'Player'
      # add player effect
      ent.lives++

      if ent.lives > ent.maxLives
        ent.lives = ent.maxLives

      # remove item
      @destroy()
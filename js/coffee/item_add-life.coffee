class item.AddLife extends Item
  constructor: (@container, @key, @spawner) ->

  color: '#cb71ff'

  onHit: (col, ent) ->
    if ent.type is 'Player'
      console.log '>>', ent
      # add player effect

      if ent.lives isnt ent.maxLives
        ent.lives++
        level?.addBlinkUpdate ent.x, ent.y, '+1', false

      # remove item
      @destroy()
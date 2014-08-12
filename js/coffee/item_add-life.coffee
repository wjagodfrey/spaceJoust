class items.AddLife
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
      # add player effect
      ent.lives++

      # remove item
      @spawner?.itemCount--
      @container?[@key] = undefined
      delete @container?[@key]

  onBuild: (level) ->

  draw: (ctx) ->
    ctx
    .save()
    .globalAlpha(0.5)
    .fillStyle('#cb71ff')
    .fillRect(Math.round(@x), Math.round(@y), @width, @height)
    .restore()
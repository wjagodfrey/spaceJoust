class Item

  type : 'Item'
  color: 'white'

  x : 0
  y : 0

  solid : false
  width : 5
  height : 5

  onHit: (col, ent) ->
    @destroy()

  destroy: ->
    @spawner?.itemCount--
    @container?[@key] = undefined
    delete @container?[@key]

  draw: (ctx) ->
    ctx
    .save()
    .fillStyle(@color)
    .fillRect(Math.round(@x), Math.round(@y), @width, @height)
    .restore()
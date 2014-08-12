class Boundary
  constructor: (@x, @y, @width, @height) ->
    @solid = true

    @type = 'Boundary'

  draw: (ctx) ->
    ctx
    .fillStyle('#1b1b1b')
    .fillRect(Math.round(@x), Math.round(@y), @width, @height)
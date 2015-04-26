class entity.Boundary
  constructor: (@x, @y, @width, @height) ->

    @type = 'Boundary'

    @cache = {}

  isSolidTo: -> true

  draw: (ctx) ->
    ctx
    .fillStyle('#1b1b1b')
    .fillRect(Math.round(@x), Math.round(@y), @width, @height)
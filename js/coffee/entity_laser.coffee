class entity.Laser
  constructor: (@x, @y, @width, @height, @on = false, @color = '#972d32') ->
    @solid = false

    @type = 'Laser'

  isSolidTo: (ent) ->
    @on

  onHit: (col, ent) ->
    if @on
      ent.die?()

  draw: (ctx) ->
    alpha = if @on then 1 else 0.1
    ctx
    .save()
    .globalAlpha(alpha)
    .fillStyle(@color)
    .fillRect(Math.round(@x), Math.round(@y), @width, @height)
    .restore()
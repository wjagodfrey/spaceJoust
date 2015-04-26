class entity.Laser
  constructor: (@x, @y, @width, @height, @on = false, @color = '#972d32') ->

    @type = 'Laser'

    @cache = {}

  isSolidTo: (ent) ->
    @on

  onHit: (col, ent) ->
    if @on and ent.type is 'Player'
      sound.play('electricburn')
      ent.die()

  draw: (ctx) ->
    alpha = if @on then 1 else 0.1
    ctx
    .save()
    .globalAlpha(alpha)
    .fillStyle(@color)
    .fillRect(Math.round(@x), Math.round(@y), @width, @height)
    .restore()
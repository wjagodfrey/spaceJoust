class Button
  constructor: (@x, @y, @onPress, @onRelease, @once, @color = '#972d32') ->
    @solid = true
    @width = 4
    @height = 2

    @type = 'Button'

  onHit: (col, ent) ->
    @hadHit = true
    if col.top and !@yCache?
      @yCache = @y
      @height = 1
      @y = @yCache+1
      ent.y++
      @onPress?(col, ent)
    else if @yCache? and !@once
      @onPress?(col, ent)

  update: ->
    if !@hadHit and @yCache?
      @height = 2
      @y = @yCache
      delete @yCache
      @onRelease?()
    @hadHit = false

  draw: (ctx) ->
    ctx
    .fillStyle(@color)
    .fillRect(Math.round(@x), Math.round(@y), @width, @height)
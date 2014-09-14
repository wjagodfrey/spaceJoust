class entity.Button
  constructor: (@x, @y, @onPress, @onRelease, @once, @color = '#972d32') ->
    @width = 4
    @height = 2

    @type = 'Button'
    @pressed = false

  isSolidTo: -> true

  onHit: (col, ent) ->
    if ent.type in ['Player', 'Bomb']
      @hadHit = true
      if col.top and !@pressed
        @pressed = true
        @yCache = @y
        @height = 1
        @y = @yCache+1
        ent.y++
        @onPress?(col, ent)
      else if @yCache? and !@once
        @onPress?(col, ent)

  update: ->
    if !@hadHit and @pressed
      @pressed = false
      @height = 2
      @y = @yCache
      delete @yCache
      @onRelease?()
    @hadHit = false

  draw: (ctx) ->
    ctx
    .fillStyle(@color)
    .fillRect(Math.round(@x), Math.round(@y), @width, @height)
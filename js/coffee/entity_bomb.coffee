class entity.Bomb
  constructor: (@ent, @key, @xBounce, @yBounce) ->
    # Bomb entity
    @type   = 'Bomb'
    @x      = @ent.x + @ent.width/2 - 3
    @y      = @ent.y + @ent.height/2 - 3
    @width  = 6
    @height = 6

    @force     = 1.3
    @direction =
      x: Math.round(Math.random()) or -1
      y: Math.round(Math.random()) or -1
    @vel =
      x: 0
      y: 0

    @explode =
      exploding: no
      size: 0
      sizeSpeed: 8
      sizeLimit: 40
      color: '#ffe2d0'

    #arming
    @armed        = false
    @hitCount     = 0
    @updateCount  = 0
    @lockoutCount = if @yBounce or @xBounce then 20 else 5

    # if @yBounce and @xBounce
    #   @timeout = setTimeout =>
    #     @boom()
    #   , 5000

  boom: ->
    clearTimeout @timeout
    level.shake.start()
    @explode.exploding = yes


  draw: (ctx) ->
    if !@explode.exploding
      ctx
      .save()
      .fillStyle('#0b0f16')
      .fillRect(Math.round(@x), Math.round(@y), @width, @height)
      .restore()

      behaviourIndicatorColor = '#425c95'
      if @xBounce
        ctx
        .save()
        .fillStyle(behaviourIndicatorColor)
        .fillRect(Math.round(@x), Math.round(@y+2), @width, @height-4)
        .restore()
      if @yBounce
        ctx
        .save()
        .fillStyle(behaviourIndicatorColor)
        .fillRect(Math.round(@x+2), Math.round(@y), @width-4, @height)
        .restore()

      ctx
      .save()
      .fillStyle(if @armed then '#b70011' else '#7eac04')
      .fillRect(Math.round(@x+1), Math.round(@y+1), @width-2, @height-2)
      .restore()



    else
      ctx
      .save()
      .fillStyle(@explode.color)
      .fillRect(Math.round(@x-@explode.size/2), Math.round(@y-@explode.size/2), @explode.size, @explode.size)
      .restore()
  update: ->
    if !@armed # check to see if it should be armed
      @updateCount++
      if @updateCount - @hitCount > @lockoutCount
        @armed = true
    else # if armed
      if @explode.exploding #if exploding
        if @explode.size < @explode.sizeLimit
          @explode.size += @explode.sizeSpeed
        else
          # remove bomb
          level.midground?[@key] = undefined
          delete level.midground?[@key]
      else if (@xBounce or @yBounce) #if not exploding and bouncable

        if @yBounce
          @vel.y = @force * @direction.y
        if @xBounce
          @vel.x = @force * @direction.x

        applyPhysics @


  onHit: (c, e, solid) ->
    #if not armed and is player who planted, reset arm timer
    if e.type is 'Player' and e.playerType is @ent.playerType and !@armed
      if @hitCount isnt @updateCount
        @hitCount = 0
        @updateCount = 0
      @hitCount++

    # if armed and is a player, detonate
    else if e.type is 'Player' and @armed
      e.die?()
      @boom()

    # if armed and is a valid object, harmlessly detonate
    else if e.type is 'Laser' and @armed and solid
      @boom()

    # otherwise bounce off things
    else if (@xBounce or @yBounce) and solid

      if @yBounce
        if c.bottom
          @direction.y = -1
        else if c.top
          @direction.y = 1
      if @xBounce
        if c.right
          @direction.x = -1
        else if c.left
          @direction.x = 1

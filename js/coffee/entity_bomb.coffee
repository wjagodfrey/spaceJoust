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

    @cache = {}

  noCorrectionWith: (ent) ->
    ent.type in ['Lava', 'Laser']

  isSolidTo: (ent) ->
    @armed

  boom: ->
    level.shake.start()
    if !@explode.exploding
      playOneOf [
        'explosion1'
        'explosion2'
        'explosion3'
      ]
    @explode.exploding = yes

  update: ->
    if !@armed # check to see if it should be armed
      @updateCount++
      if @updateCount - @hitCount > @lockoutCount
        @armed = true
    else # if armed
      if @explode.exploding #if exploding
        if @explode.size < @explode.sizeLimit
          @explode.size += @explode.sizeSpeed

          ent = @ent

          applyPhysics
            isSolidTo: -> true
            type: 'Explosion'
            x: @x-@explode.size/2
            y: @y-@explode.size/2
            width: @explode.size
            height: @explode.size
            vel:
              x: 0
              y: 0
            onHit: (c, e, solid) ->
              if e.type is 'Player' # this is how players die in explosions

                e.die()

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

    # if armed and is a valid object, harmlessly detonate
    else if (
      e.type in ['Laser','Explosion', 'Bomb'] or
      (e.type is 'Player' and !e.invincible)
    ) and
    @armed and
    solid
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

  draw: (ctx) ->
    if !@explode.exploding
      ctx
      .save()
      .fillStyle(colors.bomb.background)
      .fillRect(Math.round(@x), Math.round(@y), @width, @height)
      .restore()

      if @xBounce
        ctx
        .save()
        .fillStyle(if @armed then colors.bomb.on else colors.bomb.off)
        .fillRect(Math.round(@x), Math.round(@y+2), @width, @height-4)
        .restore()
      if @yBounce
        ctx
        .save()
        .fillStyle(if @armed then colors.bomb.on else colors.bomb.off)
        .fillRect(Math.round(@x+2), Math.round(@y), @width-4, @height)
        .restore()

      ctx
      .save()
      .fillStyle(if @armed then colors.bomb.on else colors.bomb.off)
      .fillRect(Math.round(@x+1), Math.round(@y+1), @width-2, @height-2)
      .restore()

    else # exploding
      ctx
      .save()
      .fillStyle(@explode.color)
      .fillRect(Math.round(@x-@explode.size/2), Math.round(@y-@explode.size/2), @explode.size, @explode.size)
      .restore()


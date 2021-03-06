class entity.Slime
  constructor: (@level, @height = 0) ->

    @type = 'Slime'

    @x = 0
    @y = @level.height - @height
    @width = @level.width

    @cache = {}

    randomBloop = =>
      setFrameTimeout =>
        @bloops.push
          width     : width = Math.round(6 * Math.random()) + 7
          maxHeight : height = Math.round(8 * Math.random()) + 8
          x         : Math.round((level.width + width) * Math.random()) - width/2
          growthDir : 1
          height    : 1
          speed     : ((height / 12) * 0.8) * (Math.round(Math.random() + 1.5))
        randomBloop()
      , Math.round(800 * Math.random()) + 2000
    randomBloop()

  vel:
    x: 0
    y: 0

  bloops: []

  isSolidTo: (ent) -> true

  update: ->
    @y = level.height - @height + 1
    applyPhysics @

    for i, bloop of @bloops

      if bloop.height < 1 # remove
        @bloops.splice(i, 1)
      else # update

        easing = 1 - bloop.height / bloop.maxHeight


        # width
        if bloop.growthDir > 0
          widthDelta = (bloop.width / 10) * (bloop.height / bloop.maxHeight)
          bloop.width -= widthDelta
          bloop.x += widthDelta/2

        # height
        heightDelta =
          bloop.speed *
          easing *
          bloop.growthDir

        bloop.height += heightDelta
        if bloop.height >= bloop.maxHeight - 1
          bloop.growthDir = -1



  onHit: (col, ent) ->
    if ent.type in ['Bomb', 'Item'] or
    (ent.type is 'Player' and !ent.invincible)

      @bloops.push
        x         : ent.x
        width     : ent.width
        maxHeight : height = ent.height * 1.5
        growthDir : 1
        height    : 1
        speed     : ((height / 12) * 0.8) * (Math.round(Math.random() + 1.5))

      if !ent.cache.burning
        if ent.type is 'Player'
          ent.die()
        if ent.type is 'Bomb'
          ent.boom?()
        if ent.type is 'Item'
          ent.destroy?()

        if ent.width > 4
          sound.play('burn_large')
        else
          sound.play('burn_small')

        if ent.type isnt 'Player'
          ent.cache.burning = true




  draw: (ctx) ->
    ctx
    .save()
    .globalAlpha(0.9)
    .fillStyle(colors.slime.main)
    .fillRect(Math.round(@x), Math.round(@y), @width, @height)

    for bloop in @bloops
      ctx
      .fillRect(
        Math.round(bloop.x)
        Math.round(@y - bloop.height)
        Math.round(bloop.width)
        Math.round(bloop.height + 1)
      )

    ctx.restore()
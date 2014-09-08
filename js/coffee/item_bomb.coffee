bombId = 0

class item.Bomb extends Item
  constructor: (@container, @key, @spawner, @xBounce, @yBounce) ->

  color: '#0b0f16'

  onHit: (col, ent) ->
    if ent.type is 'Player' and !ent.item? #if player doesn't have an item

      ent.item =
        use: =>

          if not hasBoxHit(
            ent.x + ent.width/2 - 3
            ent.y + ent.height/2 - 3
            6
            6
            ent.spawn.x
            ent.spawn.y
            ent.spawn.width
            ent.spawn.height
          )

            ent.item = undefined

            key = "#{ent.playerType}_bomb-#{bombId++}"

            level.midground[key] = new entity.Bomb ent, key, @xBounce, @yBounce


        draw: (ctx) =>
          width = 5
          height = 5
          ctx
          .save()
          .fillStyle(@color)
          .fillRect(Math.round(ent.x+(ent.width-width)/2), Math.round(ent.y+(ent.height-height)/2), width, height)
          .restore()
          behaviourIndicatorColor = '#425c95'
          if @xBounce
            ctx
            .save()
            .fillStyle(behaviourIndicatorColor)
            .fillRect(Math.round(ent.x+(ent.width-width)/2), Math.round(ent.y+(ent.height-height)/2+2), width, height-4)
            .restore()
          if @yBounce
            ctx
            .save()
            .fillStyle(behaviourIndicatorColor)
            .fillRect(Math.round(ent.x+(ent.width-width)/2+2), Math.round(ent.y+(ent.height-height)/2), width-4, height)
            .restore()

      # remove item
      @spawner?.itemCount--
      @container?[@key] = undefined
      delete @container?[@key]

  draw: (ctx) ->
    super ctx
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

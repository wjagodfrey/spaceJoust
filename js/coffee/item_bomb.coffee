bombId = 0

class item.Bomb extends Item
  constructor: (@container, @key, @spawner, @xBounce, @yBounce) ->

  color: colors.bomb.background

  onHit: (col, ent) ->
    if ent.type is 'Player' and !ent.item?
      super(col, ent)

  applyItem: (player) ->
    if !player.item? #if player doesn't have an item

      player.item =
        use: =>

          if not hasBoxHit(
            player.x + player.width/2 - 3
            player.y + player.height/2 - 3
            6
            6
            player.spawn.x
            player.spawn.y
            player.spawn.width
            player.spawn.height
          )

            player.item = undefined

            key = "#{player.playerType}_bomb-#{bombId++}"

            sound.play('placeBomb')

            level.midground[key] = new entity.Bomb player, key, @xBounce, @yBounce


        draw: (ctx) =>
          width = 5
          height = 5
          ctx
          .save()
          .fillStyle(@color)
          .fillRect(
            Math.round(player.x+(player.width-width)/2)
            Math.round(player.y+(player.height-height)/2)
            width
            height
          )
          .restore()
          if @xBounce
            ctx
            .save()
            .fillStyle(colors.bomb.off)
            .fillRect(
              Math.round(player.x+(player.width-width)/2)
              Math.round(player.y+(player.height-height)/2+2)
              width
              height-4
            )
            .restore()
          if @yBounce
            ctx
            .save()
            .fillStyle(colors.bomb.off)
            .fillRect(
              Math.round(player.x+(player.width-width)/2+2)
              Math.round(player.y+(player.height-height)/2)
              width-4
              height
            )
            .restore()

  draw: (ctx) ->
    super ctx
    if @xBounce
      ctx
      .save()
      .fillStyle(colors.bomb.off)
      .fillRect(Math.round(@x), Math.round(@y+2), @width, @height-4)
      .restore()
    if @yBounce
      ctx
      .save()
      .fillStyle(colors.bomb.off)
      .fillRect(Math.round(@x+2), Math.round(@y), @width-4, @height)
      .restore()

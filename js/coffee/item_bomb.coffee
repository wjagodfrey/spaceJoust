bombId = 0

class items.Bomb
  constructor: (@container, @key, @spawner) ->

  type : 'Item'

  x : 0
  y : 0

  solid : false
  width : 5
  height : 5

  onHit: (col, ent) ->
    if ent.type is 'Player' and !ent.item? #if player doesn't have an item

      ent.item =
        use: ->
          key = "#{ent.playerType}_bomb-#{bombId++}"
          level.midground[key] =
            # Bomb entity
            type: 'Bomb'
            key: key
            x: ent.x + ent.width/2 - 2.5
            y: ent.y + ent.height/2 - 2.5
            width: 6
            height: 6
            draw: (ctx) ->
              ctx
              .save()
              .fillStyle('#a90007')
              .fillRect(Math.round(@x), Math.round(@y), @width, @height)
              .fillStyle(ent.color)
              .fillRect(Math.round(@x+1), Math.round(@y+1), @width-2, @height-2)
              .restore()
            onHit: (c, e) ->
              if e.type is 'Player' and e.playerType isnt ent.playerType

                e.die()

                level.midground?[@key] = undefined
                delete level.midground?[@key]


      # remove item
      @spawner?.itemCount--
      @container?[@key] = undefined
      delete @container?[@key]

  onBuild: (level) ->

  draw: (ctx) ->
    ctx
    .save()
    .fillStyle('#0b0f16')
    .fillRect(Math.round(@x), Math.round(@y), @width, @height)
    .restore()
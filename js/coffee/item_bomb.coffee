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
            x: ent.x + ent.width/2 - 3
            y: ent.y + ent.height/2 - 3
            width: 6
            height: 6

            #arming
            armed: false
            hitCount: 0
            updateCount: 0
            lockoutCount: 20
            draw: (ctx) ->
              ctx
              .save()
              .fillStyle('#0b0f16')
              .fillRect(Math.round(@x), Math.round(@y), @width, @height)
              .fillStyle(if @armed then '#b70011' else '#7eac04')
              .fillRect(Math.round(@x+1), Math.round(@y+1), @width-2, @height-2)
              .restore()
            update: ->
              if !@armed # then check to see if it should be armed
                @updateCount++
                if @updateCount - @hitCount > @lockoutCount
                  @armed = true

            onHit: (c, e) ->
              if e.playerType is ent.playerType and !@armed
                if @hitCount isnt @updateCount
                  @hitCount = 0
                  @updateCount = 0
                @hitCount++

              if e.type is 'Player' and @armed

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
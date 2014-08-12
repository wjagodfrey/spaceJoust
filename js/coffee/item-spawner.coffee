class Item_Spawner
  constructor: (@destination, @itemTypes, @width, @height, @itemLimit = 10) ->
    @setSpawnTimer()

  itemCount: 0
  itemIdCount: 0
  setSpawnTimer: ->
    minTime = 30000
    maxTime = 2000
    time = 1#Math.round(Math.random() * minTime) + maxTime #min 2000 max 5000
    setTimeout =>
      @spawnNewItem()
      @setSpawnTimer() #DEV
    , time

  spawnNewItem: =>
    if @itemCount isnt @itemLimit
      @itemCount++
      @itemIdCount++
      key = "Level_Item_#{@itemIdCount}"
      itemTypeIndex = Math.round(Math.random() * (@itemTypes.length-1))
      itemType = @itemTypes[itemTypeIndex]
      item = new items[itemType](@destination, key, @)

      maxTries = 10
      tries = 0
      abort = false
      x = 0
      y = 0
      generateLocation = =>
        x = Math.round(Math.random() * @width)
        y = Math.round(Math.random() * @height)
        noCol = true
        console.log x, y
        for entSource in [@destination, players]
          for i, ent of entSource

            ox = ent.x
            ow = ent.width
            oy = ent.x
            oh = ent.height

            if col = hasBoxHit(
              x,y, item.width,item.height
              ent.x, ent.y, ent.width, ent.height
            )
              noCol = false
        if !noCol
          if tries++ isnt maxTries-1
            generateLocation()
          else
            abort = true
      generateLocation()

      console.log key, itemType, item
      if !abort
        item.x = x
        item.y = y
        @destination[key] = item
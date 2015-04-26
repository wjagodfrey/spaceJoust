class Item_Spawner
  constructor: (@destination, @itemTypes, @width, @height, @itemLimit = 10) ->
    @setSpawnTimer()

  itemCount: 0
  itemIdCount: 0
  setSpawnTimer: ->
    minTime = 1000
    maxTime = 10000

    # TODO dev
    devTime = 0
    @itemLimit = 10

    time = if devTime? then devTime else Math.round(Math.random() * minTime) + maxTime
    setFrameTimeout =>
      @spawnNewItem()
      @setSpawnTimer()
    , time

  spawnNewItem: =>
    if @itemCount isnt @itemLimit
      @itemCount++
      @itemIdCount++
      key = "Level_Item_#{@itemIdCount}"
      itemTypeIndex = Math.round(Math.random() * (@itemTypes.length-1))
      itemType = @itemTypes[itemTypeIndex]

      # handle arguments
      args = []
      if itemType instanceof Array
        i = itemType[0]
        args = itemType.slice(1)
        itemType = i

      newItem = new item[itemType](@destination, key, @, args...)

      maxTries = 10
      tries = 0
      abort = false
      x = 0
      y = 0
      generateLocation = =>
        x = Math.round(Math.random() * @width)
        y = Math.round(Math.random() * @height)
        noCol = true
        for entSource in [@destination, players]
          for i, ent of entSource

            ox = ent.x
            ow = ent.width
            oy = ent.x
            oh = ent.height

            if col = hasBoxHit(
              x,y, newItem.width,newItem.height
              ent.x, ent.y, ent.width, ent.height
            )
              noCol = false
        if !noCol
          if tries++ isnt maxTries-1
            generateLocation()
          else
            abort = true
      generateLocation()

      if !abort
        newItem.x = x
        newItem.y = y
        @destination[key] = newItem
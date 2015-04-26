

touchMove    = false
touchTimeout = {}

@mouse = mouse =
  x    : 0
  y    : 0
  down : false
  up   : false

gameCq = cq().framework(
  onresize: (width, height) ->
    if mouse.x > width then mouse.x = width
    if mouse.y > height then mouse.y = height
    @canvas.width = width
    @canvas.height = height
    return

  onmouseup: mouseUpHandler = (x, y, btn) ->
    mouse.down = false
    mouse.up = true

  onmousedown: mouseDownHandler = (x, y, btn) ->
    mouse.down = true

  onmousemove: mouseMoveHandler = (x, y) ->
    mouse.x = x
    mouse.y = y


  ontouchstart: (x, y, touch) ->
    if touch.length is 1
      touchDown = true
      mouseMoveHandler x, y

  ontouchmove: (x, y, touch) ->
    touchMove = true
    mouseMoveHandler x, y

  ontouchend: (x, y, touch) ->
    touchDown = false
    if !touchMove
      mouseDownHandler x, y
      touchTimeout()
      touchTimeout = setFrameTimeout ->
        mouseUpHandler x, y
      , 100
    touchMove = false

  onkeydown: (key, e) ->
    if gameKeys[key]?
      gameKeys[key]()

    # any key restarts the game
    if level?.winner
      level.reset()

    else
      for name, player of players
        if player.keys[key]? and !player.keys[key].pressed
          player.keys[key].pressed = true
          player.keys[key].press?()

  onkeyup: (key) ->
    for name, player of players
      if player.keys[key]? and player.keys[key].pressed
        player.keys[key].pressed = false
        player.keys[key].release?()


  onrender: (delta, time) ->
    @clear('#202424')

    # make resizeds show pixel edges
    @context.mozImageSmoothingEnabled    =
    @context.webkitImageSmoothingEnabled =
    @context.msImageSmoothingEnabled     =
    @context.imageSmoothingEnabled       = false

    if !loaded # HACKY LOADING SCREEN
      @.fillStyle('white')

      loadingBar =
        width: @canvas.width/2
        margin: @canvas.width/4
      loadingBar.sectionWidth = loadingBar.width / soundsToLoad.length

      # draw transparent background
      @
      .save()
      .globalAlpha(0.5)
      .fillRect(
        loadingBar.margin
        @canvas.height/2 - 50
        loadingBar.width
        100
      )
      .restore()
      # draw progress bar
      @
      .save()
      .globalAlpha(1)
      .fillRect(
        loadingBar.margin
        @canvas.height/2 - 50
        loadingBar.sectionWidth * soundsLoadedCount
        100
      )
      .restore()


      @.restore()

    else if level?

      level.render.context.mozImageSmoothingEnabled    =
      level.render.context.webkitImageSmoothingEnabled =
      level.render.context.msImageSmoothingEnabled     =
      level.render.context.imageSmoothingEnabled       = false

      resizeFactor = Math.min(gameCanvas.width / level.width, gameCanvas.height / (level.height + 20))

      # draw entities

      updateFrameTimeouts()

      level.update?()

      if !level.winner

        level.drawBackground?()

        for name, player of players
          player.update?()
          player.draw?(level.render, delta, time)
        
        level.drawMidground?()
        level.drawForeground?()

      else # HACKY WINNER SCREEN

        level.render
        .save()
        .font('2em Helvetica')
        .textAlign('center')
        .textBaseline('middle')

        if (level.winner is 'draw')
          level.render
          .fillStyle(colors.life)
          .wrappedText("It was a draw!", level.width/2, level.height/2 - 20, level.width)

        else
          level.render
          .fillStyle(players[level.winner.toLowerCase()].color)
          .wrappedText("#{level.winner} won!", level.width/2, level.height/2 - 20, level.width)
        
        level.render
        .fillStyle('white')
        .font('1em Helvetica')
        .wrappedText("press any key to play again", level.width/2, level.height/2 + 10, level.width)

        level.render.restore()


      # draw level render to game canvas
      @
      .save()
      .translate(
        (gameCanvas.width / 2 + level.offsetX) - (level.width * resizeFactor) / 2
        (gameCanvas.height / 2 + level.offsetY) - (level.height * resizeFactor) / 2
      )
      .drawImage(level.render.canvas,0,0, level.width * resizeFactor, level.height * resizeFactor)
      .restore()


    mouse.up = false

    return
)

gameCanvas = gameCq.canvas

gameCq.appendTo 'body'
gameCanvas.width  = root.innerWidth
gameCanvas.height = root.innerHeight


onEvent 'assetsLoaded', ->

  gameMusic = sound.play('gameMusic', undefined, undefined, undefined, -1)

  # gameMusic.setMute(true) # TODO dev

  loadLevel 'middle'

  mouse.x = gameCanvas.width / 2
  mouse.y = gameCanvas.height / 2
  mouse.up = false
  mouse.down = false


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

    if level?

      # make resizeds show pixel edges
      @context.mozImageSmoothingEnabled    =
      @context.webkitImageSmoothingEnabled =
      @context.msImageSmoothingEnabled     =
      @context.imageSmoothingEnabled       = false
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
        .fillStyle(players[level.winner.toLowerCase()].color)
        .wrappedText("The #{level.winner} won!", level.width/2, level.height/2 - 10, level.width)

        .font('1em Helvetica')
        .fillText('Scores:', level.width/2, level.height/2 + 10)

        .textBaseline('top')
        .fillStyle(players.alien.color)
        .fillText("Alien: #{players.alien.score}", level.width/2, level.height/2 + 20)
        .fillStyle(players.human.color)
        .fillText("Human: #{players.human.score}", level.width/2, level.height/2 + 35)

        .restore()


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

onEvent 'assetsLoaded', ->

  console.log 'loaded'

  loadLevel 'middle'

  gameCanvas.width  = root.innerWidth
  gameCanvas.height = root.innerHeight

  gameCq.appendTo 'body'

  mouse.x = gameCanvas.width / 2
  mouse.y = gameCanvas.height / 2
  mouse.up = false
  mouse.down = false
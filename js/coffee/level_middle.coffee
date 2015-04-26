# middle level
levels.level_middle =

  type: 'Map'
  name: 'middle'
  x: 0
  y: 0
  width: 300
  height: 200

  offsetX: 0
  offsetY: 0

  winner: ''

  render: cq()

  onEnd: (type) -> #WIP
    console.log 'ENDS'

  onBuild: ->

    vars = {}

    # Foreground
    # @foreground = {}


    # Midground
    @midground =

      # EDGES
      top: new entity.Boundary 0, 0, 300, 4
      bottom: new entity.Boundary 0, 196, 300, 4
      left: new entity.Boundary 0, 0, 4, 200
      right: new entity.Boundary 296, 0, 4, 200

      # SPAWNS
      # red
      spawn_red: new entity.PlayerSpawn 50, 52, 'Red'
      # blue
      spawn_blue: new entity.PlayerSpawn 230, 52, 'Blue'

      # BOUNDARIES
      row1_left: new entity.Boundary 40, 55, 60, 4
      row1_right: new entity.Boundary 200, 55, 60, 4
      row1_barrier_middle: new entity.Boundary 148, 50, 4, 25
      row1_barrier_right: new entity.Boundary 200, 59, 4, 15
      row1_barrier_left: new entity.Boundary 96, 59, 4, 15

      row2_middle: new entity.Boundary 115, 110, 70, 4
      row2_left: new entity.Boundary 30, 110, 50, 4
      row2_right: new entity.Boundary 220, 110, 50, 4

      # LASERS AND BUTTONS
      # top laser/button combo
      laser_1_right: new entity.Laser 152, 55, 48, 15, false, '#21b2b4'
      laser_1_left: new entity.Laser 100, 55, 48, 15, false, '#21b2b4'
      laser_1_button: new entity.Button 148, 108
      , ->
        level.midground.laser_1_right.on = true
        level.midground.laser_1_left.on = true
      , ->
        level.midground.laser_1_right.on = false
        level.midground.laser_1_left.on = false
      , true, '#21b2b4'

      # top laser/button combo
      laser_2_middle: new entity.Laser 148, 4, 4, 46, false
      laser_2_right_button: new entity.Button 204, 53
      , ->
        vars.laser_2_right_button =
        level.midground.laser_2_middle.on = true
      , ->
        vars.laser_2_right_button = false
        if !vars.laser_2_left_button
          level.midground.laser_2_middle.on = false
      , true
      laser_2_left_button: new entity.Button 92, 53
      , ->
        vars.laser_2_left_button =
        level.midground.laser_2_middle.on = true
      , ->
        vars.laser_2_left_button = false
        if !vars.laser_2_right_button
          level.midground.laser_2_middle.on = false
      , true

      slime: new entity.Slime @, 23


    # Item Spawner
    @spawner = new Item_Spawner(@midground, [
      'Bomb'
      ['Bomb', true, false],
      ['Bomb', false, true],
      ['Bomb', true, true]
      'NoWingsEnemy'
      'AddLife'
    ], @width, @height, 10)

    for i, source of [players, @midground, @foreground]
      for ii, ent of source
        ent?.onBuild?(@)

  shake:
    shaking: false
    speed: 3
    dir:
      x: 1
      y: 1
    dist:
      x: 6
      y: 3
    timeout: {}
    start: (duration = 300) ->
      @timeout?()
      @shaking = true
      @timeout = setFrameTimeout =>
        @shaking = false
      , duration
    update: ->

      if @shaking

        if Math.abs(level.offsetX) >= @dist.x
          @dir.x *= -1
        if Math.abs(level.offsetY) >= @dist.y
          @dir.y *= -1

        level.offsetX += @speed * @dir.x
        level.offsetY += @speed * @dir.y

      else
        level.offsetX = 0
        level.offsetY = 0

  blinkUpdates: []

  addBlinkUpdate: (x, y, text, red) ->
    @blinkUpdates.push
      x: Math.round(x)
      y: Math.round(y)
      text: text
      alpha: 1
      red: red
      container: @blinkUpdates
      update: ->
        @y -= 0.8
        @alpha -= 0.02

        if @alpha <= 0
          @container.splice(
            @container.indexOf(@)
            1
          )

      draw: (ctx) ->

        ctx
        .save()

        .globalAlpha(@alpha)

        .font('Helvetica')
        .textBaseline('top')

        .textAlign('center')
        .fillStyle(if @red then '#e00005' else '#79df06')
        .fillText(@text, @x, @y)

        .restore()

  update: ->
    @render.canvas.width = @width
    @render.canvas.height = @height
    if players.blue.lives is 0 then @winner = 'Red'
    if players.red.lives is 0 then @winner = 'Blue'
    if players.red.lives is 0 and players.blue.lives is 0
       @winner = 'draw'
    level.shake.update()

    for update in @blinkUpdates
      update?.update()


  drawBackground: ->
    @render
    .save()
    .fillStyle('#383838')
    .fillRect(0,0, @width,@height)
    .restore()

  drawMidground: ->
    @render
    .save()
    for i, ent of @midground
      ent.update?()
      ent.draw?(@render)
    @render.restore()

  drawForeground: ->
    @render
    .save()
    for i, ent of @foreground
      ent.update?()
      ent.draw?(@render)
    @render.restore()

    for update in @blinkUpdates
      update.draw @render

  reset: ->
    console.log @
    for name, ent of @midground
      delete @midground
    delete @spawner
    clearFrameTimeouts()
    @winner = ''
    @shake.shaking = false
    @onBuild()
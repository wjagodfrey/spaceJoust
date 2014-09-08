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

    # Midground
    @midground =

      # EDGES
      top: new entity.Boundary 0, 0, 300, 4
      bottom: new entity.Boundary 0, 196, 300, 4
      left: new entity.Boundary 0, 0, 4, 200
      right: new entity.Boundary 296, 0, 4, 200

      # SPAWNS
      # alien
      spawn_alien: new entity.PlayerSpawn 50, 20, 'Alien'
      # human
      spawn_human: new entity.PlayerSpawn 230, 20, 'human'

      # BOUNDARIES
      row1_left: new entity.Boundary 40, 55, 60, 4
      row1_right: new entity.Boundary 200, 55, 60, 4
      row1_barrier_middle: new entity.Boundary 148, 30, 4, 40
      row1_barrier_right: new entity.Boundary 200, 59, 4, 15
      row1_barrier_left: new entity.Boundary 96, 59, 4, 15

      row2_middle: new entity.Boundary 115, 110, 70, 4
      row2_left: new entity.Boundary 30, 110, 50, 4
      row2_right: new entity.Boundary 220, 110, 50, 4

      row3_left: new entity.Boundary 40, 150, 90, 4
      row3_right: new entity.Boundary 170, 150, 90, 4

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
      laser_2_middle: new entity.Laser 148, 4, 4, 26, false
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

      suddenDeath: new entity.SuddenDeath @, 10


    # Item Spawner
    @spawner = new Item_Spawner(@midground, [
      'Bomb'
      ['Bomb', true, false],
      ['Bomb', false, true],
      ['Bomb', true, true]
      'NoWingsEnemy'
      'AddLife'
    ], @width, @height, 7)

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
      clearTimeout @timeout
      @shaking = true
      @timeout = setTimeout =>
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

  update: ->
    @render.canvas.width = @width
    @render.canvas.height = @height
    if players.human.lives is 0 then @winner = 'Alien'
    if players.alien.lives is 0 then @winner = 'human'
    level.shake.update()

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
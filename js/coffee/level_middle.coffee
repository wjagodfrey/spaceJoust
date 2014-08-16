# middle level
levels.level_middle =

  type: 'Map'
  name: 'middle'
  x: 0
  y: 0
  width: 300
  height: 200

  winner: ''

  render: cq()

  onEnd: (type) -> #WIP
    console.log 'ENDS'

  onBuild: ->

    vars = {}

    # Midground
    @midground =

      # EDGES
      top: new Boundary 0, 0, 300, 4
      bottom: new Boundary 0, 196, 300, 4
      left: new Boundary 0, 0, 4, 200
      right: new Boundary 296, 0, 4, 200

      # SPAWNS
      # alien
      spawn_alien: new PlayerSpawn 50, 20, 'Alien'
      # human
      spawn_human: new PlayerSpawn 230, 20, 'human'

      # BOUNDARIES
      row1_left: new Boundary 40, 55, 60, 4
      row1_right: new Boundary 200, 55, 60, 4
      row1_barrier_middle: new Boundary 148, 30, 4, 40
      row1_barrier_right: new Boundary 200, 59, 4, 15
      row1_barrier_left: new Boundary 96, 59, 4, 15

      row2_middle: new Boundary 115, 110, 70, 4
      row2_left: new Boundary 30, 110, 50, 4
      row2_right: new Boundary 220, 110, 50, 4

      row3_left: new Boundary 40, 150, 90, 4
      row3_right: new Boundary 170, 150, 90, 4

      # LASERS AND BUTTONS
      # top laser/button combo
      laser_1_right: new Laser 152, 55, 48, 15, false, '#c1711f'
      laser_1_left: new Laser 100, 55, 48, 15, false, '#c1711f'
      laser_1_button: new Button 148, 108
      , ->
        level.midground.laser_1_right.on = true
        level.midground.laser_1_left.on = true
      , ->
        level.midground.laser_1_right.on = false
        level.midground.laser_1_left.on = false
      , true, '#c1711f'

      # top laser/button combo
      laser_2_middle: new Laser 148, 4, 4, 26, false
      laser_2_right_button: new Button 204, 53
      , ->
        vars.laser_2_right_button =
        level.midground.laser_2_middle.on = true
      , ->
        vars.laser_2_right_button = false
        if !vars.laser_2_left_button
          level.midground.laser_2_middle.on = false
      , true
      laser_2_left_button: new Button 92, 53
      , ->
        vars.laser_2_left_button =
        level.midground.laser_2_middle.on = true
      , ->
        vars.laser_2_left_button = false
        if !vars.laser_2_right_button
          level.midground.laser_2_middle.on = false
      , true


    # Item Spawner
    @spawner = new Item_Spawner(@midground, ['AddLife', 'Bomb', 'NoWingsEnemy'], @width, @height, 5)



    for i, source of [players, @midground, @foreground]
      for ii, ent of source
        ent?.onBuild?(@)

  update: ->
    @render.canvas.width = @width
    @render.canvas.height = @height
    if players.human.lives is 0 then @winner = 'Alien'
    if players.alien.lives is 0 then @winner = 'human'


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
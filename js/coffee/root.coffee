root = @

loaded       = false
touchDown    = false

sound = {}
gameMusic = {}

@levels   = levels = {}
@players  = players = {}
@item    = item = {}
@entity = entity = {}

@level = level = undefined

resizeFactor = 2
gravity = 0.1
colors =
  playerFlesh: '#D6BC9B'
  players:
    red: '#E0352E'
    blue: '#3D89F8'
  life: '#8aff58'
  invincible: '#64F0FF'
  noWingsEnemy: '#FECA47'
  bomb:
    off: '#939393'
    on: '#FC2639'
    background: '#222222'
  slime:
    main: '#F9631E'
  item: 'white'
  controlsDisplay:
    keyColor: '#E8E8E8'
    specialKeyColor: '#DE5A29'
    textColor: '#202020'
    specialTextColor: '#FFFFFF'


gameKeys =
  'm': ->
    gameMusic.setMute?(!gameMusic.getMute())


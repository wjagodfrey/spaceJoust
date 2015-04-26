class Item

  type : 'Item'
  color: colors.item

  x : 0
  y : 0

  width : 5
  height : 5

  alpha: 1

  speed: 10

  applyToOpponent: false
  flyToSpawn: false
  player: undefined

  flyToPlayerAndApply: ->
    if @player?
      @alpha = 0.5

      obj = if @flyToSpawn then @player.spawn else @player

      delta =
        x: (obj.x + obj.width/2) - (@x + @width/2)
        y: (obj.y + obj.height/2) - (@y + @height/2)

      direction =
        x: if Math.round(delta.x) > 0 then 1 else -1
        y: if Math.round(delta.y) > 0 then 1 else -1

      @x += Math.min(@speed, Math.abs(delta.x)) * direction.x
      @y += Math.min(@speed, Math.abs(delta.y)) * direction.y

      # if it's hit the player, 
      if (hasBoxHit(
        # item box hit dimensions
        Math.round(@x)
        Math.round(@y)
        @width
        @height
        # player box hit dimesions
        Math.round(obj.x)
        Math.round(obj.y)
        obj.width
        obj.height
      ))
        sound.play('blop')
        @applyItem(@player)
        @destroy()


  onHit: (col, ent) ->
    if ent.type is 'Player' and !@player?
      @player = if @applyToOpponent then ent.other else ent

  applyItem: (player) ->

  destroy: ->
    @spawner?.itemCount--
    @container?[@key] = undefined
    delete @container?[@key]

  update: ->
    @flyToPlayerAndApply()

  draw: (ctx) ->
    ctx
    .save()
    .fillStyle(@color)
    .globalAlpha(@alpha)
    .fillRect(Math.round(@x), Math.round(@y), @width, @height)
    .restore()
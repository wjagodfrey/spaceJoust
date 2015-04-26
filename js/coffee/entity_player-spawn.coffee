class entity.PlayerSpawn
  constructor: (@x, @y, playerType) ->

    @player = players[playerType.toLowerCase()]

    @width = 20
    @height = 3


    @player?.spawn = @

    @type = 'Spawn'

    @lifeCounterOn = lightenDarkenColor(colors.life, 0);
    @lifeCounterOff = lightenDarkenColor(colors.life, -100);

    @beamHeight = 25
    @beamAlpha = 0

    @cache = {}

    @controlsDisplay =
      alpha: 1
      fade: false
      width: 8
      height: 8
      margin: 2
      keyDepth: 1
      faderTimeout: setTimeout =>
        console.log @controlsDisplay
        @controlsDisplay.fade = true
      , 3000

  lockoutCount: 30

  isSolidTo: (ent) ->
    true

  onBuild: (level) ->
    @reset()

  reset: ->
    @player?.x = @x + @width/2 - @player?.width/2
    @player?.y = @y + @height/2 - @player?.height/2 - 15

    @beamAlpha = 0.8

    @player.invincible = true
    @player.invincibleTimeout = setFrameTimeout =>
      @player.invincible = false
    , 1000

    sound.play('buzzer')

  update: ->
    if (@beamAlpha > 0)
      @beamAlpha -= 0.05
      if (@beamAlpha < 0)
        @beamAlpha = 0

    if (@controlsDisplay.fade and @controlsDisplay.alpha > 0)
      @controlsDisplay.alpha -= 0.05
      if (@controlsDisplay.alpha < 0)
        @controlsDisplay.alpha = 0


  draw: (ctx) ->

    # draw transparent player color
    ctx
    .save()
    .globalAlpha(0.6)
    .fillStyle(lightenDarkenColor(@player.color, 50))
    .fillRect(Math.round(@x), Math.round(@y - 1), @width, @height)
    .restore()

    # draw transparent white color
    ctx
    .save()
    .globalAlpha(@beamAlpha)
    .fillStyle(@player.color)
    .fillRect(Math.round(@x), Math.round(@y - @beamHeight), @width, @beamHeight)
    .restore()

    # draw dark color
    ctx
    .save()
    .fillStyle('#303030')
    .fillRect(
      Math.round(@x)
      Math.round(@y + @height - 3)
      @width
      4
    )
    .restore()

    # draw life counters
    barWidth = Math.floor((@width) / @player.maxLives)
    lifeCount = 0
    while lifeCount < @player.maxLives
      ctx
      .save()

      .fillStyle(
        if lifeCount >= @player.lives
          @lifeCounterOff
        else
          @lifeCounterOn
      )
      .fillRect(
        Math.round(@x + (barWidth * lifeCount))
        Math.round(
          (@y + @height) - 2
        )
        barWidth
        2
      )
      .restore()

      lifeCount++


    # draw controls
    totalXOffset = @controlsDisplay.width + @controlsDisplay.margin
    totalYOffset = @controlsDisplay.height + @controlsDisplay.margin + @controlsDisplay.keyDepth
    isRed = @player.playerType is 'red'
    keyOpts = [
      {
        x: Math.round(@x + @width/2 - @controlsDisplay.width/2)
        y: Math.round(@y - 20 - totalYOffset*2)
        text: if isRed then 'W' else '⬆'
      }
      {
        x: Math.round(@x + @width/2 - @controlsDisplay.width/2)
        y: Math.round(@y - 20 - totalYOffset)
        text: if isRed then 'S' else '⬇'
      }
      {
        x: Math.round(@x + @width/2 - @controlsDisplay.width/2 - totalXOffset)
        y: Math.round(@y - 20 - totalYOffset)
        text: if isRed then 'A' else '⬅'
      }
      {
        x: Math.round(@x + @width/2 - @controlsDisplay.width/2 + totalXOffset)
        y: Math.round(@y - 20 - totalYOffset)
        text: if isRed then 'D' else '➡'
      }
      {
        x: Math.round(@x + @width/2 - @controlsDisplay.width/2 + (totalXOffset*2) * if isRed then 1 else -1)
        y: Math.round(@y - 20 - totalYOffset)
        text: if isRed then 'G' else '.'
        keyColor: colors.controlsDisplay.specialKeyColor
        textColor: colors.controlsDisplay.specialTextColor
      }
    ]
    for keyOpt in keyOpts
      keyColor = keyOpt.keyColor or colors.controlsDisplay.keyColor
      textColor = keyOpt.textColor or colors.controlsDisplay.textColor
      ctx
      .save()
      .globalAlpha(@controlsDisplay.alpha)

      .fillStyle(keyColor)
      .fillRect(
        keyOpt.x
        keyOpt.y
        @controlsDisplay.width
        @controlsDisplay.height
      )

      .fillStyle(lightenDarkenColor(keyColor, -50))
      .fillRect(
        keyOpt.x
        keyOpt.y + @controlsDisplay.height
        @controlsDisplay.width
        @controlsDisplay.keyDepth
      )

      .fillStyle(textColor)

      .font('8px Helvetica')
      .textAlign('center')
      .textBaseline('middle')
      .wrappedText(
        keyOpt.text
        keyOpt.x + @controlsDisplay.width/2
        keyOpt.y + @controlsDisplay.height/2 + 1
      )

      .restore()

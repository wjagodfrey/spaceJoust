class entity.Score

  update: ->
    for score in level.floatingScores
      score.update()

  draw: (ctx) ->
    for score in level.floatingScores
      score.draw ctx

    ctx
    .save()

    .globalAlpha(0.7)

    .font('Helvetica')
    .textBaseline('top')

    .textAlign('left')
    .fillStyle(players.alien.color)
    .fillText(players.alien.score, 3,2)

    .textAlign('right')
    .fillStyle(players.human.color)
    .fillText(players.human.score, level.width-3,2)

    .restore()
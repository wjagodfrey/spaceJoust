'use strict'

hasMouseHit = (x, y, width, height) ->
  col = 
    x : (x + width / 2  >= mouse.x and x - width / 2  <= mouse.x)
    y : (y + height / 2 >= mouse.y and y - height / 2 <= mouse.y)

  if col.x and col.y
    return true
  else
    return false

hasBoxHit = (_ax, _ay, _awidth, _aheight, _bx, _by, _bwidth, _bheight) ->

  aX = _ax
  aXX = _ax + _awidth
  aY = _ay
  aYY = _ay + _aheight
  bX = _bx
  bXX = _bx + _bwidth
  bY = _by
  bYY = _by + _bheight

  col = 
    x : (aX >= bX and aX <= bXX or aXX >= bX and aXX <= bXX) or (bX >= aX and bX <= aXX or bXX >= aX and bXX <= aXX)
    y : (aY >= bY and aY <= bYY or aYY >= bY and aYY <= bYY) or (bY >= aY and bY <= aYY or bYY >= aY and bYY <= aYY)

  if col.x and col.y
    return {
      left   : aX >= bX and aX <= bXX
      right  : aXX >= bX and aXX <= bXX
      top    : aY >= bY and aY <= bYY
      bottom : aYY >= bY and aYY <= bYY
    }
  else
    return false

loadLevel = (name) =>
  root.level = level = levels["level_#{name}"] or {}
  level.onBuild?()

addPlayerVelocity = (player, name, vector) ->
  players[player].vel.mod[name] = {}
  if vector.x
    players[player].vel.mod[name].x = vector.x
  if vector.y
    players[player].vel.mod[name].y = vector.y

removePlayerVelocity = (player, name) ->
  delete players[player].vel.mod[name]

playerHitsAndVelocity = (player) ->

  xCorrection = 1
  yCorrection = 1

  for entSource in [level?.midground, [player.other]]
    for i, ent of entSource

      ox = ent.x
      ow = ent.width
      oy = ent.x
      oh = ent.height

      if col = hasBoxHit(
        player.x + player.vel.x,player.y + player.vel.y, player.width,player.height
        ent.x, ent.y, ent.width, ent.height
      )

        solid =
        ent.solid or # Solid object
        (ent.isSolidTo?(player)) # Is other teams' spawner

        xDepth = 0
        yDepth = 0

        # get shallow axis

        if col.left and col.right
          xDepth = player.width
        else if !col.left and !col.right
          xDepth = ent.width
        else if col.left and !col.right
          xDepth = player.width - ((player.x + player.vel.x + player.width) - (ent.x + ent.width))
        else if !col.left and col.right
          xDepth = player.width - (ent.x - (player.x + player.vel.x))

        if col.top and col.bottom
          yDepth = player.height
        else if !col.top and !col.bottom
          yDepth = ent.height
        else if col.top and !col.bottom
          yDepth = player.height - ((player.y + player.vel.y + player.height) - (ent.y + ent.height))
        else if !col.top and col.bottom
          yDepth = player.height - (ent.y - (player.y + player.vel.y))


        collisions =
          top    : false
          bottom : false
          left   : false
          right  : false

        if xDepth and yDepth
          # collision on the left moving left
          if (xDepth < yDepth or !player.vel.y) and player.vel.x < 0 and (col.left or !col.right)
            # ax - bxx
            correction = ((player.x) - (ent.x + ent.width)) / Math.abs(player.vel.x)
            if correction < xCorrection and solid
              xCorrection = correction
            collisions.right = true
            player.events?.left_col?(ent)
          # collision on the right moving right
          else if (xDepth < yDepth or !player.vel.y) and player.vel.x > 0 and (col.right or !col.left)
            # bx - axx
            correction = (ent.x - (player.x + player.width)) / Math.abs(player.vel.x)
            if correction < xCorrection and solid
              xCorrection = correction
            collisions.left = true
            player.events?.right_col?(ent)

          # collision on the top moving up
          if (yDepth < xDepth or !player.vel.x) and player.vel.y < 0 and (col.top or !col.bottom)
            # ay - byy
            correction = ((player.y) - (ent.y + ent.height)) / Math.abs(player.vel.y)
            if correction < yCorrection and solid
              yCorrection = correction
            collisions.bottom = true
            player.events?.top_col?(ent)
          # collision on the bottom moving down
          else if (yDepth < xDepth or !player.vel.x) and player.vel.y > 0 and (col.bottom or !col.top)
            # by - ayy
            correction = (ent.y - (player.y + player.height)) / Math.abs(player.vel.y)
            if correction < yCorrection and solid
              yCorrection = correction
            collisions.top = true
            player.events?.bottom_col?(ent)

        ent.onHit?(collisions, player)

  player.x += (player.vel.x * xCorrection)
  player.y += (player.vel.y * yCorrection)

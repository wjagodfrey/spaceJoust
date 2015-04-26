'use strict'

# event sys
events = {}
onEvent = (eventName, eventHandler) ->
  events[eventName] ?= []
  events[eventName].push eventHandler
  ->
    events[eventName].splice events[eventName].indexOf(eventHandler), 1
fireEvent = (eventName, args...) ->
  if events[eventName]?.length
    for eventHandler in events[eventName]
      eventHandler(args...)

playOneOf = (sounds) ->
  randomSound = Math.round(Math.random() * (sounds.length - 1))
  sound.play(sounds[randomSound])

# frame dependant timing functions (won't keep running if tab isn't visible)
@frameCount = 0
@frameTimeouts = frameTimeouts = {}
setFrameTimeout = (callback, time = 0) ->
  targetFrame = root.frameCount + Math.ceil(time * 0.06)
  if targetFrame <= (root.frameCount + 1)
    setTimeout callback
  else
    frameTimeouts[targetFrame] ?= []
    frameTimeouts[targetFrame].push callback
    removed = false
    return =>
      if !removed
        if frameTimeouts[targetFrame]
          frameTimeouts[targetFrame].splice(frameTimeouts[targetFrame].indexOf(callback), 1)
        removed = true
updateFrameTimeouts = ->
  targetFrame = root.frameCount++
  if frameTimeouts[targetFrame]
    for callback in frameTimeouts[targetFrame]
      callback()
    frameTimeouts[targetFrame] = undefined
    delete frameTimeouts[targetFrame]
clearFrameTimeouts = ->
  for targetFrame, callback of frameTimeouts
    delete frameTimeouts[targetFrame]



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

@lightenDarkenColor = lightenDarkenColor = (col, amt) ->
  usePound = false
  if col[0] is "#"
    col = col.slice(1)
    usePound = true
  num = parseInt(col, 16)
  r = (num >> 16) + amt
  if r > 255
    r = 255
  else r = 0  if r < 0
  b = ((num >> 8) & 0x00FF) + amt
  if b > 255
    b = 255
  else b = 0  if b < 0
  g = (num & 0x0000FF) + amt
  if g > 255
    g = 255
  else g = 0  if g < 0
  ((if usePound then "#" else "")) + (g | (b << 8) | (r << 16)).toString(16)

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

applyPhysics = (ent1) ->

  xCorrection = 1
  yCorrection = 1


  for entSource in [level?.midground, players]
    for i, ent2 of entSource

      if ent1 isnt ent2

        if col = hasBoxHit(
          ent1.x + ent1.vel.x
          ent1.y + ent1.vel.y
          ent1.width
          ent1.height

          ent2.x
          ent2.y
          ent2.width
          ent2.height
        )

          ent1Solid = ent1.isSolidTo?(ent2)
          ent2Solid = ent2.isSolidTo?(ent1)

          ent1Collisions =
            top    : false
            bottom : false
            left   : false
            right  : false
          ent2Collisions =
            top    : false
            bottom : false
            left   : false
            right  : false

          if ent1Solid and ent2Solid

            xDepth = 0
            yDepth = 0

            # get shallow axis

            if col.left and col.right
              xDepth = ent1.width
            else if !col.left and !col.right
              xDepth = ent2.width
            else if col.left and !col.right
              xDepth = ent1.width - ((ent1.x + ent1.vel.x + ent1.width) - (ent2.x + ent2.width))
            else if !col.left and col.right
              xDepth = ent1.width - (ent2.x - (ent1.x + ent1.vel.x))

            if col.top and col.bottom
              yDepth = ent1.height
            else if !col.top and !col.bottom
              yDepth = ent2.height
            else if col.top and !col.bottom
              yDepth = ent1.height - ((ent1.y + ent1.vel.y + ent1.height) - (ent2.y + ent2.height))
            else if !col.top and col.bottom
              yDepth = ent1.height - (ent2.y - (ent1.y + ent1.vel.y))



            runCorrection = !ent1.noCorrectionWith?(ent2) and !ent2.noCorrectionWith?(ent1)

            if xDepth and yDepth
              # collision on the left moving left
              if (xDepth < yDepth or !ent1.vel.y) and ent1.vel.x < 0 and (col.left or !col.right)
                if runCorrection
                  # ax - bxx
                  correction = ((ent1.x) - (ent2.x + ent2.width)) / Math.abs(ent1.vel.x)
                  if correction < xCorrection
                    xCorrection = correction
                ent1Collisions.left = true
                ent2Collisions.right = true
              # collision on the right moving right
              else if (xDepth < yDepth or !ent1.vel.y) and ent1.vel.x > 0 and (col.right or !col.left)
                if runCorrection
                  # bx - axx
                  correction = (ent2.x - (ent1.x + ent1.width)) / Math.abs(ent1.vel.x)
                  if correction < xCorrection
                    xCorrection = correction
                ent1Collisions.right = true
                ent2Collisions.left = true

              # collision on the top moving up
              if (yDepth < xDepth or !ent1.vel.x) and ent1.vel.y < 0 and (col.top or !col.bottom)
                if runCorrection
                  # ay - byy
                  correction = ((ent1.y) - (ent2.y + ent2.height)) / Math.abs(ent1.vel.y)
                  if correction < yCorrection
                    yCorrection = correction
                ent1Collisions.top = true
                ent2Collisions.bottom = true
              # collision on the bottom moving down
              else if (yDepth < xDepth or !ent1.vel.x) and ent1.vel.y > 0 and (col.bottom or !col.top)
                if runCorrection
                  # by - ayy
                  correction = (ent2.y - (ent1.y + ent1.height)) / Math.abs(ent1.vel.y)
                  if correction < yCorrection
                    yCorrection = correction
                ent1Collisions.bottom = true
                ent2Collisions.top = true

          ent2.onHit?(ent2Collisions, ent1, ent1Solid)
          ent1.onHit?(ent1Collisions, ent2, ent2Solid)

  ent1.x += (ent1.vel.x * xCorrection)
  ent1.y += (ent1.vel.y * yCorrection)
root = @

loaded       = false
frame        = 0
touchDown    = false

@levels   = levels = {}
@players  = players = {}
@item    = item = {}
@entity = entity = {}
@HUD      = HUD = []

@level = level = undefined

resizeFactor = 2
gravity = 0.1

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

setTimeout ->
  fireEvent 'assetsLoaded'

# loaded = false
# frameCount = 0
# loadedFrameCount = 0

# root.onload = ->
#   # load resources
#   for spriteName, sprite of sprites
#     for groupName, group of sprite.actions
#       for frameIndex, frame of group.frames
#         do (spriteName, sprite, groupName, group, frameIndex, frame) ->
#           frameCount++
#           img = document.createElement('img')
#           img.onload = ->
#             group.frames[frameIndex] = img
#             loadedFrameCount++
#             # set to true if frames are loaded
#             if frameCount is loadedFrameCount
#               loaded = true
#               console.log 'loaded', sprites
#               fireEvent 'assetsLoaded'

#           img.src = frame

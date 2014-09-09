setFrameTimeout ->
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

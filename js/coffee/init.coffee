loaded = false
frameCount = 0
loadedFrameCount = 0

soundsLoadedCount = 0
soundsToLoad = [
  {src:"sounds/BoxCat_Games_-_03_-_Battle_Special.mp3", id:"gameMusic"}

  {src:"sounds/Buzzer-SoundBible.com-188422102.mp3", id:"buzzer"}

  {src:"sounds/Blop-Mark_DiAngelo-79054334.mp3", id:"blop"}

  {src:"sounds/Baseball Bat Swing-SoundBible.com-1511319491.mp3", id:"flap"}
  
  {src:"sounds/Click2-Sebastian-759472264.mp3", id:"button_up"}
  {src:"sounds/Button-SoundBible.com-1420500901.mp3", id:"button_down"}

  {src:"sounds/Barrel Exploding-SoundBible.com-1134967902.mp3", id:"explosion1"}
  {src:"sounds/Explosion 2-SoundBible.com-1641389556.mp3", id:"explosion2"}
  {src:"sounds/Grenade Explosion-SoundBible.com-2100581469.mp3", id:"explosion3"}

  {src:"sounds/Small Fireball-SoundBible.com-1381880822.mp3", id:"burn_small"}
  {src:"sounds/Large Fireball-SoundBible.com-301502490.mp3", id:"burn_large"}
  
  {src:"sounds/Fizzle-SoundBible.com-1439537520.mp3", id:"electricburn"}
  
  {src:"sounds/Drop Fork-SoundBible.com-309369294.mp3", id:"placeBomb"}

  {src:"sounds/Slap-SoundMaster13-49669815.mp3", id:"pop"}
]

root.onload = ->
  sound = createjs.Sound



  sound.alternateExtensions = ["mp3"]
  sound.on("fileload", ->
    if (soundsLoadedCount++ is soundsToLoad.length-1)
      # sound.setMute(true)
      setTimeout ->
        loaded = true
        fireEvent 'assetsLoaded'
      , 2000
  )
  sound.registerSounds(soundsToLoad)
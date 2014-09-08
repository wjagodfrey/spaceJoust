require 'colors'
connect     = require("connect")
http        = require("http")
serveStatic = require("serve-static")
fs          = require 'fs'
{exec}      = require 'child_process'


###
  build task
###

task 'build', 'Watch all jade, stylus and coffeescript files and build appropriately', ->
  jsPref = 'js/coffee/'
  jsFiles = [
    "#{jsPref}init.coffee"
    "#{jsPref}util.coffee"
    "#{jsPref}entity_boundary.coffee"
    "#{jsPref}entity_button.coffee"
    "#{jsPref}entity_laser.coffee"
    "#{jsPref}entity_player-spawn.coffee"
    "#{jsPref}entity_bomb.coffee"
    "#{jsPref}entity_sudden-death.coffee"
    "#{jsPref}item.coffee"
    "#{jsPref}item-spawner.coffee"
    "#{jsPref}item_add-life.coffee"
    "#{jsPref}item_no-wings-enemy.coffee"
    "#{jsPref}item_bomb.coffee"
    "#{jsPref}level_middle.coffee"
    "#{jsPref}player.coffee"
    "#{jsPref}player_human.coffee"
    "#{jsPref}player_alien.coffee"
    "#{jsPref}framework.coffee"
  ].join(' ')

  console.log '========='.bold.cyan, 'COFFEE FILES'.bold.magenta, '========='.bold.cyan
  console.log (jsFiles.split(' ').join('\n')).green.bold
  console.log '============'.bold.cyan, 'OUTPUT'.bold.magenta, '============'.bold.cyan, '\n'

  questTask = exec "
    jade --watch *.jade &
    coffee -w -j js/index.js -c #{jsFiles} &
    stylus -w css/ && fg
  ", (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
  questTask.stdout.on 'data', (data) -> console.log data
  questTask.stderr.on 'data', (data) -> console.log data + "\x07"


###
  dev server task
###

task 'start', 'Start a simple python HTTP file server', (options) ->
  console.log 'Starting dev server on port'.cyan.bold, '8000'.red
  http.createServer(connect().use(serveStatic(__dirname))).listen 8000

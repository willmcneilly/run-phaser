FPS = require './fps'



module.exports = class Game
  constructor: (game) ->
    @game = game
    @cursor = null
    @velocity = 200
    @enemyTimeDelta = 0
    @enemySpawnTime = 500

  preload: ->
    @game.load.spritesheet 'dude', '/assets/images/dude.png', 32, 48
    @game.load.spritesheet 'enemy', '/assets/images/enemy.png', 26, 24

  create: ->
    @game.stage.backgroundColor = '#eeeeee';
    @fpsText = new FPS(@game)
    @cursor = @game.input.keyboard.createCursorKeys()
    @createPlayer()
    @createEnemies()

  update: ->
    @fpsText.update()
    @updatePlayer()
    @updateEnemies()

  createPlayer: ->
    @player = @game.add.sprite 20, 20, 'dude'
    @player.animations.add 'left', [0..3], 10, true
    @player.animations.add 'right', [5..8], 10, true

  updatePlayer: ->
    @player.body.velocity.x = 0
    @player.body.velocity.y = 0

    if @cursor.left.isDown
      @player.body.velocity.x = -@velocity
      @player.animations.play 'left'
    else if @cursor.right.isDown
      @player.body.velocity.x = @velocity
      @player.animations.play 'right'
    else if @cursor.up.isDown
      @player.body.velocity.y = -@velocity
    else if @cursor.down.isDown
      @player.body.velocity.y = @velocity
    else
      @player.animations.stop()
      @player.frame = 4

  createEnemies: ->
    @enemies = @game.add.group()
    @enemies.createMultiple(30, 'enemy')
    @enemies.setAll('outOfBoundsKill', true)

  updateEnemies: ->
    if @game.time.now > @enemyTimeDelta
      @spawnEnemy()

  spawnEnemy: ->
    @enemyTimeDelta = @game.time.now + @enemySpawnTime
    enemy = @enemies.getFirstExists(false)
    randomCorner = 0

    switch randomCorner
      when 0
        x = @random(@game.width)
        y = -enemy.height/2+2
        tox = @random(@game.width)
        toy = @game.width + enemy.height
    enemy.reset(x, y)
    enemy.angle = 90 + Math.atan2(y - toy, x - tox) * 180 / Math.PI
    @game.add.tween(enemy).to( { x: tox, y: toy }, 4000, Phaser.Easing.Linear.None).start()

  random: (num) ->
    return Math.floor(Math.random() * num)

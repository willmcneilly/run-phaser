FPS = require './fps'

module.exports = class Game
  constructor: (game) ->
    @game = game
    @cursor = null
    @velocity = 200

  preload: ->
    @game.load.spritesheet 'dude', '/assets/images/dude.png', 32, 48
    @game.load.spritesheet 'enemy', '/assets/images/enemy.png', 26, 24

  create: ->
    @game.stage.backgroundColor = '#eeeeee';
    @fpsText = new FPS(@game)
    @cursor = @game.input.keyboard.createCursorKeys()
    @createPlayer()
    @enemies = @game.add.group()
    @enemies.createMultiple(30, 'enemy')
    @enemies.setAll('outOfBoundsKill', true)

  update: ->
    @fpsText.update()
    @updatePlayer()

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

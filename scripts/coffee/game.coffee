FPS = require './fps'

module.exports = class Game
  constructor: (game) ->
    @game = game

  preload: ->
    console.log 'preloading'

  create: ->
    @fpsText = new FPS(@game)

  update: ->
    @fpsText.update()

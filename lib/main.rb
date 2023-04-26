# frozen_string_literal: true

require_relative './rack'
require_relative './display'
require_relative './game'

game = Game.new
game.play_game

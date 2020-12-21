local gui = require "gui"
local cards = require "cards"
local handmanager = require "handmanager"
local deckmanager = require "deckmanager"
local boardmanager = require "boardmanager"

local game = {}

-- The current game state
local state = "select"


game.load = function()
  boardmanager.load()
  deckmanager.load()
  handmanager.load()
end

game.update = function(dt)
  boardmanager.update(dt)
  deckmanager.update(dt)
  handmanager.update(dt)
end

game.draw = function()
  boardmanager.draw()
  deckmanager.draw()
  handmanager.draw()
end

game.mousepressed = function(x, y, button)
  if state == "select" then
    boardmanager.mousepressed(x, y, button)
    handmanager.mousepressed(x, y, button)
  end
end

game.keypressed = function(key)
  if state == "select" then
    handmanager.keypressed(key)
  end
end

return game

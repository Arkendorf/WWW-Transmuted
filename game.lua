local gui = require "gui"
local cards = require "cards"
local handmanager = require "handmanager"
local deckmanager = require "deckmanager"
local boardmanager = require "deckmanager"

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
  -- for i, card in ipairs(handmanager.hand) do
  --   if handmanager.selected == i then
  --     love.graphics.print(card.name, 20, i*12)
  --   else
  --     love.graphics.print(card.name, 0, i*12)
  --   end
  -- end
end

game.mousepressed = function(x, y, button)
  if state == "select" then
    handmanager.mousepressed(x, y, button)
  end
end

game.keypressed = function(key)
  if state == "select" then
    handmanager.keypressed(key)
  end
end

return game

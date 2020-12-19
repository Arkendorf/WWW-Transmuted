local gui = require "gui"
local cards = require "cards"
local handmanager = require "handmanager"

local game = {}

-- The current game state
local state = "select"

-- the cards in your deck
local deck = {}

game.load = function()
  -- Replace deck generation later, perhaps allow customization
  for i = 1, 20 do
    deck[i] = cards[math.random(1, #cards)]
  end
  handmanager.fill_hand(deck)
end

game.update = function(dt)
  handmanager.update(dt)
end

game.draw = function()
  handmanager.draw()
  for i, card in ipairs(handmanager.hand) do
    if handmanager.selected == i then
      love.graphics.print(card.name, 20, i*12)
    else
      love.graphics.print(card.name, 0, i*12)
    end
  end
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

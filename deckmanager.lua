local cards = require "cards"

local deckmanager = {}

deckmanager.deck = {}
deckmanager.deck_size = 10

deckmanager.card_w = 100
deckmanager.card_h = 160

deckmanager.x = love.graphics.getWidth() - deckmanager.card_w - deckmanager.deck_size
deckmanager.y = love.graphics.getHeight() - deckmanager.card_h

deckmanager.load = function()
  -- Replace deck generation later, perhaps allow customization
  for i = 1, deckmanager.deck_size do
    deckmanager.deck[i] = cards[math.random(1, #cards)]
  end
end

deckmanager.update = function(dt)
end

deckmanager.draw = function()
  for i, card in ipairs(deckmanager.deck) do
    love.graphics.rectangle("line", deckmanager.x + i - 1, deckmanager.y, deckmanager.card_w, deckmanager.card_h)
  end
end

return deckmanager

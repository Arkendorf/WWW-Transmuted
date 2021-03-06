local cards = require "cards"
local graphics = require "graphics"

local deckmanager = {}

deckmanager.deck = {}
deckmanager.deck_size = 20

deckmanager.card_w = 98
deckmanager.card_h = 138

deckmanager.load = function()
  -- Determine deck graphic position
  deckmanager.x = 0
  deckmanager.y = get_window_h() - deckmanager.card_h

  deckmanager.deck = {}
  for i = 1, deckmanager.deck_size do
    deckmanager.deck[i] = cards[i % (#cards + 1)]
  end
end

deckmanager.update = function(dt)
end

deckmanager.draw = function()
  for i, card in ipairs(deckmanager.deck) do
    love.graphics.draw(graphics.images.card_back, math.floor(deckmanager.x) + i - 1, math.floor(deckmanager.y))
  end
end

return deckmanager

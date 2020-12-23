local cards = require "cards"

local deckmanager = {}

deckmanager.deck = {}
deckmanager.deck_size = 20

deckmanager.card_w = 64
deckmanager.card_h = 96

deckmanager.load = function()
  -- Determine dech graphic position
  deckmanager.x = get_window_w() - deckmanager.card_w - deckmanager.deck_size
  deckmanager.y = get_window_h() - deckmanager.card_h

  -- Replace deck generation later, perhaps allow customization
  for i = 1, deckmanager.deck_size do
    deckmanager.deck[i] = cards[i % 20]
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

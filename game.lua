local gui = require "gui"
local cards = require "cards"
local handmanager = require "handmanager"
local deckmanager = require "deckmanager"
local boardmanager = require "boardmanager"
local network = require "network"

local game = {}

-- The current game state
game.state = "place"

game.player_turn = {}
game.opponent_turn = {}
game.player_placed = false
game.opponent_placed = false


game.load = function()
  boardmanager.load()
  deckmanager.load()
  handmanager.load()

  -- Saved data on player and opponent cards placed this turn
  game.player_placed = false
  game.opponent_placed = false

  -- Function that is called when a card is placed on the board
  boardmanager.network_card_placed = function(card, lane, type)
    -- Mark that the player has placed their card
    game.player_placed = true
    -- Save important info on the card the player just placed
    game.player_turn.card = card
    game.player_turn.lane = lane
    -- Let the opponent know that the player has placed their card
    game.queue("placed", true)
    -- If the opponent already placed their card, it is okay to tell them what card the player placed
    if game.opponent_placed then
      game.queue("card", game.player_turn)
    end
    -- Change the state
    game.state = "wait"
  end
  -- Called when the opponent has placed their card
  network.add_callback("placed", function(data)
    game.opponent_placed = true
    -- If the player has also placed their card already, it is now safe for the player to send the opponent their card
    if game.player_placed then
      game.queue("card", game.player_turn)
    end
  end)
  -- Called when the opponent sends their card data to the player
  network.add_callback("card", function(data)
    -- Save the card data
    game.opponent_turn = data
  end)
  -- Set the networked keys for card data
  network.set_keys("card", {"card", "lane"})
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
  boardmanager.mousepressed(x, y, button)
  handmanager.mousepressed(x, y, button)
end

game.keypressed = function(key)
  handmanager.keypressed(key)
end

-- Should be overridden depending on whether this user is a server or client
game.queue = function(event, data)
end

return game

local gui = require "gui"
local cards = require "cards"
local handmanager = require "handmanager"
local deckmanager = require "deckmanager"
local boardmanager = require "boardmanager"
local attackmanager = require "attackmanager"
local charmanager = require "charmanager"
local particlemanager = require "particlemanager"
local graphics = require "graphics"
local guimanager = require "guimanager"
local audio = require "audio"

local network = require "network"

local game = {}

-- The current game state
game.state = "place"
game.message = false

-- Data about the players' turns
game.player_turn = {}
game.opponent_turn = {}
-- Whether players have placed their card this turn
game.player_placed = false
game.opponent_placed = false

-- Whether or not opponent is out of cards
game.player_out = false
game.opponent_out = false


game.load = function()
  boardmanager.load()
  deckmanager.load()
  handmanager.load()
  attackmanager.load()
  charmanager.load()
  particlemanager.load()

  game.load_gui()

  game.state = "place"
  game.message = false

  -- Saved data on player and opponent cards placed this turn
  game.player_placed = false
  game.opponent_placed = false

  -- Whether or not opponent is out of cards
  game.player_out = false
  game.opponent_out = false

  -- Start background music
  audio.title:stop()
  audiomanager.play(audio.bgm)

  -- Function that is called when a card is placed on the board
  boardmanager.network_card_placed = function(card, lane, type)
    -- Mark that the player has placed their card
    game.player_placed = true
    -- Save important info on the card the player just placed
    game.player_turn.card_num = card.num
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
  network.set_keys("card", {"card_num", "lane"})

  -- Whether the opponent is out of cards
  network.add_callback("out", function(data)
    game.opponent_out = true
  end)

  -- Called when the opponent is telling the player their name
  network.add_callback("name", function(data)
    charmanager.opponent.name = data
  end)
  -- Set name
  charmanager.player.name = mainmenu.name
  -- Send player name
  game.queue("name", charmanager.player.name)

  -- Sent when the opponent disconnects
  network.add_callback("disconnect", function()
    game.forfeit()
  end)
end

-- Function that loads all the gui elements
game.load_gui = function()
  -- reset gui
  guimanager.reset_window()
  -- Set up gui
  local buffer = guimanager.buffer
  local w, h = guimanager.icon_element_w, guimanager.icon_element_h
  local x, y = get_window_w() - w - buffer, get_window_h() - h - buffer
  gui.new_icon_button("menu", x, y, w, h, 1, game.toggle_options)
end

-- Toggles the options menu
game.toggle_options = function()
  if game.state ~= "over" then
    options.toggle(game.load_gui)
  end
end

game.update = function(dt)
  boardmanager.update(dt)
  deckmanager.update(dt)
  handmanager.update(dt)
  attackmanager.update(dt)
  charmanager.update(dt)
  particlemanager.update(dt)
end

game.draw = function()
  charmanager.draw()
  boardmanager.draw()
  deckmanager.draw()
  attackmanager.draw()
  handmanager.draw()
  particlemanager.draw()
end

game.mousepressed = function(x, y, button)
  boardmanager.mousepressed(x, y, button)
  handmanager.mousepressed(x, y, button)
end

game.keypressed = function(key)
  handmanager.keypressed(key)
  if key == "escape" then
    game.toggle_options()
  end
end

-- Should be overridden depending on whether this user is a server or client
game.queue = function(event, data)
end

game.win = function()
  game.message = "Victory"
  game.over()
end

game.lose = function()
  game.message = "Defeat"
  game.over()
end

game.tie_death = function()
  game.message = "Mutual Destruction"
  game.over()
end

game.tie_out = function()
  game.message = "Magic Exhausted"
  game.over()
end

game.forfeit = function()
  game.message = "Opponent Forfeited"
  game.over()
end

game.over = function()
  game.state = "over"
  -- Set up gui
  guimanager.set_title(game.message)
  guimanager.new_button("leave", guimanager.bottom_slot, "Leave", game.leave)
end

-- Should be overridden
game.leave = function()
end

return game

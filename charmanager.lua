local deckmanager = require "deckmanager"
local attackmanager = require "attackmanager"
local graphics = require "graphics"

local charmanager = {}

-- Player objects
charmanager.player = {type = "char"}
charmanager.opponent = {type = "char"}

-- Size of the character on screen
charmanager.char_w = 162
charmanager.char_h = 258

-- Starting hp of characters
charmanager.char_hp = 20

charmanager.load = function()
  -- Set initial player pos and hp
  charmanager.player.x = 0
  charmanager.player.y = (get_window_h() - charmanager.char_h - deckmanager.card_h) / 2
  charmanager.player.value = charmanager.char_hp

  -- Set initial opponent pos and hp
  charmanager.opponent.x = get_window_w() - charmanager.char_w
  charmanager.opponent.y = charmanager.player.y
  charmanager.opponent.value = charmanager.char_hp

  -- Set who is who
  if mode == "server" then
    charmanager.player.char = "gandalf"
    charmanager.opponent.char = "crimson"
  else
    charmanager.player.char = "crimson"
    charmanager.opponent.char = "gandalf"
  end
end

charmanager.update = function(dt)
  -- Check if the characters have died
  local player_dead = charmanager.player.value <= 0
  local opponent_dead = charmanager.opponent.value <= 0

  -- Check for endgame scenarios
  -- Tie game
  if player_dead and opponent_dead then
    game.tie()
  elseif player_dead then -- Defeat
    game.lose()
  elseif opponent_dead then -- Victory!
    game.win()
  end

  -- Update players
  for i, char in ipairs({charmanager.player, charmanager.opponent}) do
    if char.shake then
      char.shake = char.shake - dt
    end
  end
end

-- Draw both players
charmanager.draw = function()
  charmanager.draw_char(charmanager.player)
  charmanager.draw_char(charmanager.opponent)
end

-- Draws a character
charmanager.draw_char = function(char_data)
  local x, y = char_data.x, char_data.y
  if char_data.shake and char_data.shake > 0 then
    x = x + math.random(-attackmanager.shake_mag, attackmanager.shake_mag)
    y = y + math.random(-attackmanager.shake_mag, attackmanager.shake_mag)
  end
  if char_data.char == "crimson" then
    love.graphics.draw(graphics.images.crimson_wizard, x, y)
  else
    love.graphics.draw(graphics.images.gandalf, x, y)
  end
  love.graphics.print(char_data.value, x, y)
end

return charmanager

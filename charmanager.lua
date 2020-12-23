local charmanager = {}

-- Player objects
charmanager.player = {type = "char"}
charmanager.opponent = {type = "char"}

-- Size of the character on screen
charmanager.char_w = 100
charmanager.char_h = 100

-- Starting hp of characters
charmanager.char_hp = 20

charmanager.load = function()
  -- Set initial player pos and hp
  charmanager.player.x = charmanager.char_w / 2
  charmanager.player.y = love.graphics.getHeight() / 2
  charmanager.player.value = charmanager.char_hp

  -- Set initial opponent pos and hp
  charmanager.opponent.x = love.graphics.getWidth() - charmanager.char_w / 2
  charmanager.opponent.y = charmanager.player.y
  charmanager.opponent.value = charmanager.char_hp
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
end

-- Draw both players
charmanager.draw = function()
  charmanager.draw_char(charmanager.player)
  charmanager.draw_char(charmanager.opponent)
end

-- Draws a character
charmanager.draw_char = function(char_data)
  love.graphics.circle("line", char_data.x, char_data.y, charmanager.char_w / 2, 50)
  love.graphics.print(char_data.value, char_data.x, char_data.y)
end

return charmanager

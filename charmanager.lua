local charmanager = {}

charmanager.player = {type = "char"}
charmanager.opponent = {type = "char"}

charmanager.char_w = 100
charmanager.char_h = 100

charmanager.char_hp = 20

charmanager.load = function()
  charmanager.player.x = charmanager.char_w / 2
  charmanager.player.y = love.graphics.getHeight() / 2
  charmanager.player.value = charmanager.char_hp

  charmanager.opponent.x = love.graphics.getWidth() - charmanager.char_w / 2
  charmanager.opponent.y = charmanager.player.y
  charmanager.opponent.value = charmanager.char_hp
end

charmanager.update = function(dt)
end

charmanager.draw = function()
  charmanager.draw_char(charmanager.player)
  charmanager.draw_char(charmanager.opponent)
end

charmanager.draw_char = function(char_data)
  love.graphics.circle("line", char_data.x, char_data.y, charmanager.char_w / 2, 50)
  love.graphics.print(char_data.value, char_data.x, char_data.y)
end

return charmanager

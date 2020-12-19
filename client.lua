local network = require "network"
local game = require "game"

local client = {}

client.load = function()
  math.randomseed(os.time())
  game.load()
end

client.update = function(dt)
  game.update(dt)
end

client.draw = function()
  game.draw()
end

client.quit = function()
  network.client.quit()
end

client.mousepressed = function(x, y, button)
  game.mousepressed(x, y, button)
end

client.keypressed = function(key)
  game.keypressed(key)
end

return client

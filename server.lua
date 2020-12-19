local network = require "network"
local game = require "game"

local server = {}

local opponent

server.load = function(peer)
  math.randomseed(os.time()+1)
  opponent = peer
  game.load()
end

server.update = function(dt)
  game.update(dt)
end

server.draw = function()
  game.draw()
end

server.quit = function()
  network.server.quit()
end

server.mousepressed = function(x, y, button)
  game.mousepressed(x, y, button)
end

server.keypressed = function(key)
  game.keypressed(key)
end

return server

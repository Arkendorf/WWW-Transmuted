local network = require "network"
local gui = require "gui"

local server = {}

local opponent = false

server.load = function(peer)
  math.randomseed(os.time()+1)
  opponent = peer

  game.load()

  game.queue = function(event, data)
    network.server.queue(event, data, opponent)
  end

  game.leave = function()
    network.server.quit()
    gui.remove_all()
    mode = "mainmenu"
    mainmenu.load()
  end
end

server.update = function(dt)
  network.server.update(dt)
  game.update(dt)

  -- If opponent has left, end game
  if #network.server.get_peers() < 1 then
    game.message = "Opponent forfeited"
    game.over()
  end
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

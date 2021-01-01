local network = require "network"

local server = {}

local opponent = false

server.load = function(peer)
  math.randomseed(os.time()+1)
  opponent = peer

  game.queue = function(event, data)
    network.server.queue(event, data, opponent)
  end

  game.leave = function()
    network.server.quit()
    mode = "mainmenu"
    mainmenu.load()
  end

  game.load()
end

server.update = function(dt)
  network.server.update(dt)
  game.update(dt)
end

server.draw = function()
  game.draw()
end

server.quit = function()
  -- Queue a message telling clients server has quit
  network.server.queue_all("quit")
  -- Force it to send
  network.server.send_queue()
  network.server.quit()
end

server.mousepressed = function(x, y, button)
  game.mousepressed(x, y, button)
end

server.keypressed = function(key)
  game.keypressed(key)
end

return server

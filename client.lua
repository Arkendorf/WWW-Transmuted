local network = require "network"

local client = {}

client.load = function()
  math.randomseed(os.time())

  game.queue = function(event, data)
    network.client.queue(event, data)
  end

  game.leave = function()
    network.client.quit()
    mode = "mainmenu"
    mainmenu.load()
  end

  game.load()
end

client.update = function(dt)
  network.client.update(dt)
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

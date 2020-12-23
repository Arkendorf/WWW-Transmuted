local network = require "network"
local gui = require "gui"

local client = {}

client.load = function()
  math.randomseed(os.time())

  game.load()

  game.queue = function(event, data)
    network.client.queue(event, data)
  end

  game.leave = function()
    network.client.quit()
    gui.remove_all()
    mode = "mainmenu"
    mainmenu.load()
  end
end

client.update = function(dt)
  network.client.update(dt)
  game.update(dt)

  -- If opponent has left, end game
  if network.client.get_status == "disconnected" then
    game.message = "Opponent forfeited"
    game.over()
  end
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

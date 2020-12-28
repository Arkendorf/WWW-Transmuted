local network = require "network"
local gui = require "gui"

local preserver = {}

local address = false

preserver.load = function()
  -- Start the server, and save the adress
  network.server.start()
  address = network.server.get_address()
  network.server.set_broadcasting(true)

  -- Set up the gui
  gui.new_button("leave", 0, 20, 128, 24, "Leave", preserver.leave)

  -- Callback for when client connects
  network.add_callback("connect", function(data, peer)
    -- Stop broadcasting when an opponent has been found
    network.server.set_broadcasting(false)

    -- Switch to main server mode
    gui.remove_all()
    mode = "server"
    server.load(peer)
  end)
end

preserver.update = function(dt)
  network.server.update(dt)
end

preserver.draw = function()
  love.graphics.print("Waiting for an opponent")
end

preserver.leave = function()
  network.server.quit()
  gui.remove_all()
  mode = "mainmenu"
  mainmenu.load()
end

preserver.quit = function()
  network.server.quit()
end

return preserver

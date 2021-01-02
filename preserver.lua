local network = require "network"
local gui = require "gui"
local guimanager = require "guimanager"

local preserver = {}

local address = false

preserver.load = function()
  -- Start the server, and save the adress
  network.server.start()
  address = network.server.get_address()
  network.server.set_broadcasting(true)
  network.server.set_bonus_string(mainmenu.name)

  -- Reset gui
  guimanager.reset_window()
  -- Set up gui
  guimanager.set_title("Host Match")
  guimanager.new_text("msg", 1, "Waiting for an opponent", "center")
  guimanager.new_button("leave", guimanager.bottom_slot, "Leave", preserver.leave)

  -- Callback for when client connects
  network.add_callback("connect", function(data, peer)
    -- Stop broadcasting when an opponent has been found
    network.server.set_broadcasting(false)

    -- Switch to main server mode
    guimanager.reset_window()
    mode = "server"
    server.load(peer)
  end)
end

preserver.update = function(dt)
  network.server.update(dt)
end

preserver.draw = function()
  mainmenu.draw()
end

preserver.leave = function()
  network.server.quit()
  mode = "mainmenu"
  mainmenu.load()
end

preserver.quit = function()
  network.server.quit()
end

return preserver

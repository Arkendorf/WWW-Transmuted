local network = require "network"
local gui = require "gui"

local preclient = {}

local status = "disconnected"

preclient.load = function()
  network.client.start()

  -- Callback for when client connects to server
  network.add_callback("connect", function()
    -- switch to main client mode
    gui.remove_all()
    mode = "client"
    client.load()
  end)
end

preclient.update = function(dt)
  if network.client.get_status() == "disconnected" then
    gui.remove_all()
    local num = 0
    for i, address in ipairs(network.client.get_addresses()) do
      gui.new_button("server" .. tostring(i), 0, 16 + (i-1)*28, 128, 24, tostring(i)..". "..address, preclient.server_button, address)
      num = i
    end
    gui.new_button("leave", 0, 16 + num*28, 128, 24, "Back to Main", preclient.leave)
  end

  network.client.update(dt)
end

preclient.server_button = function(address)
  if address then
    if network.client.connect(address) then
      -- Returns true here
    end
  end
end

preclient.draw = function()
  love.graphics.print("Searching for matches...")
end

preclient.leave = function()
  network.client.quit()
  gui.remove_all()
  mode = "mainmenu"
  mainmenu.load()
end

preclient.quit = function()
  network.client.quit()
end

return preclient

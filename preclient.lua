local network = require "network"
local gui = require "gui"
local guimanager = require "guimanager"

local preclient = {}

local status = "disconnected"

preclient.load = function()
  network.client.start()

  -- Reset gui
  guimanager.reset_window()
  -- Set up gui
  guimanager.set_title("Find Match")

  -- Callback for when client connects to server
  network.add_callback("connect", function()
    -- switch to main client mode
    guimanager.reset_window()
    mode = "client"
    client.load()
  end)
end

preclient.update = function(dt)
  if network.client.get_status() == "disconnected" then
    -- Clear out gui
    guimanager.reset_slots()
    -- Add text message
    guimanager.new_text("msg", 1, "Searching for matches...", "center")
    -- Add new gui
    local num = 0
    for i, data in ipairs(network.client.get_addresses()) do
      guimanager.new_button("server" .. tostring(i), i + 1, data.bonus_string, preclient.server_button, data.address)
      num = i
    end
    -- Add back button
    guimanager.new_button("leave", math.max(num + 2, guimanager.bottom_slot), "Leave", preclient.leave)
  end

  network.client.update(dt)
end

preclient.server_button = function(address)
  if address then
    if network.client.connect(address) then
    end
  end
end

preclient.draw = function()
  mainmenu.draw()
end

preclient.leave = function()
  network.client.quit()
  mode = "mainmenu"
  mainmenu.load()
end

preclient.quit = function()
  network.client.quit()
end

return preclient

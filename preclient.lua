local network = require "network"
local gui = require "gui"

local preclient = {}

local status = "disconnected"

--local mx, my = 400, 300

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
      gui.new_button("server" .. tostring(i), 0, 20 + (i-1)*50, 200, 50, tostring(i)..". "..address, preclient.server_button, address)
      num = i
    end
    gui.new_button("leave", 0, 20 + num*50, 200, 50, "Back to Main", preclient.leave)
  end

  network.client.update(dt)
end

preclient.server_button = function(address)
  if address then
    if network.client.connect(address) then

      -- network.add_callback("mouse", function(data)
      --   mx = data.x
      --   my = data.y
      -- end)
    end
  end
end

preclient.draw = function()
  --status = network.client.get_status()
  --love.graphics.print(status, 100, 0)
  love.graphics.print("Searching for matches...")

  --love.graphics.circle("fill", mx, my, 16, 16)
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
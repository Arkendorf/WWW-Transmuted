local gui = require "gui"
local guimanager = require "guimanager"
local graphics = require "graphics"

local mainmenu = {}

mainmenu.name = "Wizard"

mainmenu.load = function()
  -- Reset gui
  guimanager.reset_window()
  -- Set up the gui
  guimanager.set_title("Witchy Wizard War")
  guimanager.new_textbox("name", 1, "Name", mainmenu, "name")
  guimanager.new_button("host", 2, "Host Match", mainmenu.host_button)
  guimanager.new_button("find", 3, "Find Match", mainmenu.find_button)
  guimanager.new_button("quit", guimanager.bottom_slot, "Quit", mainmenu.quit)
end

mainmenu.update = function(dt)
end

mainmenu.draw = function(dt)
end

mainmenu.host_button = function()
  mode = "preserver"
  preserver.load()
end

mainmenu.find_button = function()
  mode = "preclient"
  preclient.load()
end

mainmenu.quit = function()
  love.event.quit()
end

return mainmenu

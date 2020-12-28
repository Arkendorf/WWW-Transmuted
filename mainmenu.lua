local gui = require "gui"

local mainmenu = {}

mainmenu.name = ""

mainmenu.load = function()
  gui.load()
  gui.new_textbox("name", 0, 0, 128, 24, "Name", mainmenu, "name")
  gui.new_button("host", 0, 28, 128, 24, "Host Match", mainmenu.host_button)
  gui.new_button("find", 0, 56, 128, 24, "Find Match", mainmenu.find_button)
  gui.new_button("quit", 0, 84, 128, 24, "Quit", mainmenu.quit)
end

mainmenu.update = function(dt)
end

mainmenu.draw = function(dt)
end

mainmenu.host_button = function()
  gui.remove_all()
  mode = "preserver"
  preserver.load()
end

mainmenu.find_button = function()
  gui.remove_all()
  mode = "preclient"
  preclient.load()
end

mainmenu.quit = function()
  love.event.quit()
end

return mainmenu

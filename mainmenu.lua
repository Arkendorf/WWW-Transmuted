local gui = require "gui"

local mainmenu = {}

mainmenu.load = function()
  gui.load()
  gui.new_button("host", 0, 0, 200, 50, "Host Match", mainmenu.host_button)
  gui.new_button("find", 0, 50, 200, 50, "Find Match", mainmenu.find_button)
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

return mainmenu

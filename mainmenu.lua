local gui = require "gui"
local guimanager = require "guimanager"
local graphics = require "graphics"
local charmanager = require "charmanager"
local audio = require "audio"

local mainmenu = {}

mainmenu.name = "Wizard"

mainmenu.logo_buffer = 24

mainmenu.logo_x = 0
mainmenu.logo_y = 0

mainmenu.load = function()
  -- Reset gui
  gui.remove_all()
  guimanager.reset_window()

  -- Set up the gui
  -- Central x position
  local x = get_window_w() / 2
  -- Gui element w and h
  local element_w, element_h = guimanager.element_w, guimanager.element_h
  -- Buffer in pixels between UI elements
  local buffer = guimanager.buffer
  -- Height of the logo
  local logo_h = graphics.images.logo:getHeight()
  -- Height of the total menu
  local menu_h = element_h * 3 + buffer * 2 -- Should always be one less buffer than element height
  -- Y position above which is the logo, and below which is the gui
  local y = (get_window_h() + logo_h - menu_h + mainmenu.logo_buffer) / 2

  -- Add the gui buttons
  gui.new_textbox("name", x - element_w - buffer / 2, y, element_w, element_h, "Name", mainmenu, "name")
  gui.new_button("host", x + buffer / 2, y, element_w, element_h, "Host Match", mainmenu.host_button)
  gui.new_button("find", x + buffer / 2, y + element_h + buffer, element_w, element_h, "Find Match", mainmenu.find_button)
  gui.new_button("quit", x - element_w / 2, y + (element_h + buffer) * 2, element_w, element_h, "Quit", mainmenu.quit)
  gui.new_icon_button("menu", x - element_w - buffer / 2, y + element_h + buffer, guimanager.icon_element_h, guimanager.icon_element_h, 1, mainmenu.options)

  -- Get the logo position
  mainmenu.logo_x = (get_window_w() - graphics.images.logo:getWidth()) / 2
  mainmenu.logo_y = y - logo_h - mainmenu.logo_buffer

  -- Start background music
  if not audio.title:isPlaying() then
    audio.bgm:stop()
    audiomanager.play(audio.title, .05)
  end
end

mainmenu.update = function(dt)
end

mainmenu.draw = function(dt)
  -- Draw the logo
  love.graphics.draw(graphics.images.logo, mainmenu.logo_x, mainmenu.logo_y)

  -- Get y position of wizards
  local y = math.floor((get_window_h() - charmanager.char_h) / 2)
  -- Get buffer between wizards and the wall
  local buffer = (get_window_w() - guimanager.w) / 4
  -- Draw wizards
  love.graphics.draw(graphics.images.crimson_wizard, buffer - charmanager.char_w / 2, y)
  love.graphics.draw(graphics.images.gandalf, get_window_w() - charmanager.char_w / 2 - buffer, y)
end

mainmenu.host_button = function()
  -- Remove the gui
  gui.remove_all()

  mode = "preserver"
  preserver.load()
end

mainmenu.find_button = function()
  -- Remove the gui
  gui.remove_all()

  mode = "preclient"
  preclient.load()
end


-- Called when option button is pressed
mainmenu.options = function()
  -- Remove the gui
  gui.remove_all()

  options.open(mainmenu.load)
end

mainmenu.quit = function()
  love.event.quit()
end

return mainmenu

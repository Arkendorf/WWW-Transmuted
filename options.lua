local guimanager = require "guimanager"
local palettes = require "palettes"
local audio = require "audio"

local options = {}

options.active = false

options.palette = 1
options.music = true

options.open = function(exit_func)
  -- Reset gui
  guimanager.reset_window()
  -- Set up gui
  guimanager.set_title("Options")
  guimanager.new_selector("palette", 1, "Palette", options.palette_change)
  guimanager.new_checkbox("music", 2, "Music", options.music_toggle, options.music)
  guimanager.new_button("main", guimanager.bottom_slot - 1, "Main Menu", options.main)
  guimanager.new_button("back", guimanager.bottom_slot, "Back", options.exit)

  options.exit_func = exit_func

  options.active = true
end

options.toggle = function(exit_func)
  if options.active then
    options.exit()
  else
    options.open(exit_func)
  end
end

options.exit = function()
  -- Reset gui
  guimanager.reset_window()

  if options.exit_func then
    options.exit_func()
  end

  options.active = false
end

options.main = function()
  options.exit()
  if mode == "server" or mode == "client" then
    game.leave()
  end
  mainmenu.load()
end

-- Toggles the music option
options.music_toggle = function()
  options.music = not options.music

  audio.title:setVolume(options.music and audio.title_volume or 0)
  audio.bgm:setVolume(options.music and audio.bgm_volume or 0)

  return options.music
end

-- Called when a palette button is pressed
options.palette_change = function(change)
  -- Change the palette number
  options.palette = (options.palette + change)
  -- Reset if value is too large or small
  if options.palette > #palettes then
    options.palette = 1
  elseif options.palette < 1 then
    options.palette = #palettes
  end
  -- Set the colors
  options.set_palette(options.palette)
end

-- Set the palette to the one represented by the given index
options.set_palette = function(palette)
  shaders.palette:send("light", palettes[palette].light)
  shaders.palette:send("dark", palettes[palette].dark)
  love.graphics.setBackgroundColor(palettes[palette].dark)
  -- Remember the palette number
  options.palette = palette
end

return options

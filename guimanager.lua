local graphics = require "graphics"
local gui = require "gui"

local guimanager = {}

-- Whether the gui window is active
guimanager.active = false
-- The wiindow title
guimanager.title = ""

-- The position and dimensions of the gui window
guimanager.x = 0
guimanager.y = 0
guimanager.w = 0
guimanager.h = 0

-- The dimensions of a gui element
guimanager.element_w = 0
guimanager.element_h = 0

-- The element slots
guimanager.slots = {}

-- The amount of pixels between gui elements
guimanager.buffer = 4
guimanager.bottom_slot = 8

guimanager.load = function()
  -- Load the gui
  gui.load()
  -- Start off with no gui window
  guimanager.active = false

  -- Get position and dimensions
  guimanager.x = math.floor(get_window_w() / 2)
  guimanager.y = math.floor(get_window_h() / 2)
  guimanager.w = graphics.gui.menu:getWidth()
  guimanager.h = graphics.gui.menu:getHeight()

  guimanager.element_w = graphics.gui.button:getWidth()
  guimanager.element_h = graphics.gui.button:getHeight()

  guimanager.title = ""

  guimanager.slots = {}
end

guimanager.update = function(dt)
  -- Update the gui
  gui.update(dt)
end

guimanager.draw = function()
  -- Only draw gui window if it is active
  if guimanager.active then
    -- Get the gui window position
    local x, y = guimanager.get_window_pos()
    -- Draw the window back
    love.graphics.draw(graphics.gui.menu, x, y)

    -- Draw the window title
    love.graphics.setFont(graphics.fonts.large)
    love.graphics.printf(guimanager.title, x, y + 8, guimanager.w, "center")
  end
  gui.draw()
end

guimanager.get_window_pos = function()
  return guimanager.x - guimanager.w / 2, guimanager.y - guimanager.h / 2
end

-- Sets the gui window title
guimanager.set_title = function(title)
  guimanager.title = title
  guimanager.active = true
end

-- Adds a button to the window
guimanager.new_button = function(id, slot, text, func, args)
  -- Deletes any button previously in the given slot
  guimanager.delete_slot(slot)
  -- Get the elements position
  local x, y = guimanager.get_position(slot)
  -- Add the button
  gui.new_button(id, x, y, guimanager.element_w, guimanager.element_h, text, func, args)
  -- Note that the slot is full
  guimanager.slots[slot] = {type = "button", id = id}
  -- Set the gui as active, if it wasn't already
  guimanager.active = true
end

-- Adds a button to the window
guimanager.new_textbox = function(id, slot, text, table, index)
  -- Deletes any button previously in the given slot
  guimanager.delete_slot(slot)
  -- Get the elements position
  local x, y = guimanager.get_position(slot)
  -- Add the button
  gui.new_textbox(id, x, y, guimanager.element_w, guimanager.element_h, text, table, index)
  -- Note that the slot is full
  guimanager.slots[slot] = {type = "button", id = id}
  -- Set the gui as active, if it wasn't already
  guimanager.active = true
end

guimanager.new_text = function(id, slot, text, mode)
  -- Deletes any button previously in the given slot
  guimanager.delete_slot(slot)
  -- Get the elements position
  local x, y = guimanager.get_position(slot)
  x = guimanager.get_window_pos()
  -- Add the button
  gui.new_text(id, x, y, guimanager.w, text, mode)
  -- Note that the slot is full
  guimanager.slots[slot] = {type = "text", id = id}
  -- Set the gui as active, if it wasn't already
  guimanager.active = true
end


-- Returns the position for an element in the given slot
guimanager.get_position = function(slot)
  local x = guimanager.x - (guimanager.w - guimanager.element_w) / 2
  local y = guimanager.y - guimanager.h / 2 + 28 + (slot - 1) * (guimanager.element_h + guimanager.buffer)
  return x, y
end

-- Deletes the element in the given slot, if it exists
guimanager.delete_slot = function(slot)
  -- Get a reference to the element
  local old_element = guimanager.slots[slot]
  -- If it exists, delete it
  if old_element then
    if old_element.type == "button" then
      gui.remove_button(old_element.id)
    elseif old_element.type == "textbox" then
      gui.remove_textbox(old_element.id)
    elseif old_element.type == "text" then
      gui.remove_text(old_element.id)
    end
  end
  guimanager.slots[slot] = false
end

-- Resets the gui window
guimanager.reset_window = function()
  -- Set gui window as inactive
  guimanager.active = false
  guimanager.title = ""
  -- Clean out the slots
  guimanager.reset_slots()
end

-- Resets the window's slots
guimanager.reset_slots = function()
  -- Clean up slots
  for k, v in pairs(guimanager.slots) do
    guimanager.delete_slot(k)
  end
  -- Remove the gui
  gui.remove_all()
end

return guimanager

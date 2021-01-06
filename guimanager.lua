local graphics = require "graphics"
local gui = require "gui"

local guimanager = {}

-- Whether the gui window is active
guimanager.active = false

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

  guimanager.icon_element_w = graphics.gui.icon_button:getWidth()
  guimanager.icon_element_h = graphics.gui.icon_button:getHeight()

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

guimanager.pre_add = function(slot, type, id)
  -- Deletes any button previously in the given slot
  guimanager.delete_slot(slot)
  -- Note that the slot is full
  guimanager.slots[slot] = {type = type, id = id}
  -- Set the gui as active, if it wasn't already
  guimanager.active = true
  -- Get the elements position
  return guimanager.get_position(slot)
end

-- Adds a button to the window
guimanager.new_button = function(id, slot, text, func, args)
  local x, y = guimanager.pre_add(slot, "button", id)
  -- Add the button
  gui.new_button(id, x, y, guimanager.element_w, guimanager.element_h, text, func, args)
end

-- Adds a button to the window
guimanager.new_icon_button = function(id, slot, icon, func, args)
  local x, y = guimanager.pre_add(slot, "button", id)
  -- Add the button
  gui.new_icon_button(id, x, y, guimanager.icon_element_w, guimanager.icon_element_h, icon, func, args)
end

-- Adds a button to the window
guimanager.new_textbox = function(id, slot, text, table, index)
local x, y = guimanager.pre_add(slot, "textbox", id)
  -- Add the textbox
  gui.new_textbox(id, x, y, guimanager.element_w, guimanager.element_h, text, table, index)
end

guimanager.new_text = function(id, slot, text, mode)
  local x, y = guimanager.pre_add(slot, "text", id)
  x = guimanager.get_window_pos()
  -- Add the button
  gui.new_text(id, x, y, guimanager.w, text, mode)
end

guimanager.new_selector = function(id, slot, text, func)
  local w, h = guimanager.icon_element_w, guimanager.icon_element_h
  local x, y = guimanager.pre_add(slot, "selector", id)

  gui.new_icon_button(id .. "-", x, y, w, h, 2, function(args)
    func(-1)
  end)
  gui.new_icon_button(id .. "+", x + guimanager.element_w - w, y, w, h, 3, function(args)
    func(1)
  end)
  gui.new_text(id, x + w, y, guimanager.element_w - w * 2, text, "center")
end

guimanager.new_checkbox = function(id, slot, text, func, default)
  local w, h = guimanager.icon_element_w, guimanager.icon_element_h
  local x, y = guimanager.pre_add(slot, "checkbox", id)

  gui.new_icon_button(id .. "_button", x + guimanager.element_w - w, y, w, h, default and 4 or 5, function(args)
    if func() then
      gui.edit_button(id .. "_button", "icon", 4)
    else
      gui.edit_button(id .. "_button", "icon", 5)
    end
  end)
  gui.new_text(id, x, y, guimanager.element_w - w, text, "left")
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
    elseif old_element.type == "selector" then
      gui.remove_button(old_element.id .. "-")
      gui.remove_button(old_element.id .. "+")
      gui.remove_text(old_element.id)
    elseif old_element.type == "checkbox" then
      gui.remove_button(old_element.id .. "_button")
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
end

return guimanager

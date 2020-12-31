local graphics = require "graphics"

local gui = {}

local buttons = {}
local textboxes = {}
local textbox = nil

local highlight = nil

local t = 0
local thresh = .5

gui.load = function()
  love.keyboard.setKeyRepeat(true)
end

gui.update = function(dt)
  -- Get highlight
  highlight = nil
  local x, y = get_mouse_pos()
  for k, v in pairs(buttons) do
    if x >= v.x and x <= v.x+v.w and y >= v.y and y <= v.y+v.h then
      highlight = k
    end
  end
  for k, v in pairs(textboxes) do
    if x >= v.x and x <= v.x+v.w and y >= v.y and y <= v.y+v.h then
      highlight = k
    end
  end

  -- Textbox blink timer
  t = t + dt
  if t > thresh * 2 then
    t = 0
  end
end

gui.draw = function()
  for k, v in pairs(buttons) do
    if highlight == k then
      love.graphics.draw(graphics.gui.button_highlight, v.x, v.y)
    else
      love.graphics.draw(graphics.gui.button, v.x, v.y)
    end
    love.graphics.setFont(graphics.fonts.large)
    love.graphics.print(v.text, v.x + 6, v.y + 6)

    --love.graphics.rectangle("line", v.x, v.y, v.w, v.h)
    --love.graphics.print(v.text, v.x, v.y)
  end
  for k, v in pairs(textboxes) do
    -- Set text
    local text = v.text
    if v.table[v.index] ~= "" or textbox == k then
      text = tostring(v.table[v.index])
    end
    -- Choose background
    if textbox == k then
      love.graphics.draw(graphics.gui.textbox_selected, v.x, v.y)
      if t > thresh then
        text = text .. "|"
      end
    elseif highlight == k then
      love.graphics.draw(graphics.gui.textbox_highlight, v.x, v.y)
    else
      love.graphics.draw(graphics.gui.textbox, v.x, v.y)
    end
    -- Draw text
    love.graphics.setFont(graphics.fonts.large)
    love.graphics.print(text, v.x + 6, v.y + 6)

    -- love.graphics.rectangle("line", v.x, v.y, v.w, v.h)
  end
end

gui.mousepressed = function(x, y, button)
  local x, y = get_mouse_pos()
  local click_used = false
  for k, v in pairs(buttons) do
    if x >= v.x and x <= v.x+v.w and y >= v.y and y <= v.y+v.h then
      v.func(v.args)
      click_used = true
      textbox = nil
      break
    end
  end
  if not click_used then
    for k, v in pairs(textboxes) do
      if x >= v.x and x <= v.x+v.w and y >= v.y and y <= v.y+v.h then
        textbox = k
        click_used = true
        break
      end
    end
  end
  if not click_used then
    textbox = nil
  end
end

gui.keypressed = function(key)
  if textbox and key == "backspace" then
    textboxes[textbox].table[textboxes[textbox].index] = string.sub(textboxes[textbox].table[textboxes[textbox].index], 1, -2)
  end
end

gui.textinput = function(text)
  if textbox then
    textboxes[textbox].table[textboxes[textbox].index] = textboxes[textbox].table[textboxes[textbox].index]..text
  end
end

gui.new_button = function(id, x, y, w, h, text, func, args)
  buttons[id] = {x = x, y = y, w = w, h = h, text = text, func = func, args = args}
end

gui.edit_button = function(id, item, value)
  if buttons[id] then
    buttons[id][item] = value
  end
end

gui.remove_button = function(id)
  buttons[id] = nil
end

gui.new_textbox = function(id, x, y, w, h, text, table, index)
  textboxes[id] = {x = x, y = y, w = w, h = h, text = text, table = table, index = index}
end

gui.edit_textbox = function(id, item, value)
  if textboxes[id] then
    textboxes[id][item] = value
  end
end

gui.remove_textbox  = function(id)
  textboxes[id] = nil
end

gui.remove_all = function()
  buttons = {}
  textboxes = {}
end

return gui

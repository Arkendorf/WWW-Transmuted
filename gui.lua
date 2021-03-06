local graphics = require "graphics"
local audio = require "audio"

local gui = {}

local buttons = {}
local texts = {}
local textboxes = {}
local textbox = nil

local highlight = nil

local t = 0
local thresh = .5

gui.load = function()
  love.keyboard.setKeyRepeat(true)
  gui.remove_all()
end

gui.update = function(dt)
  -- Get highlight
  local old_highlight = highlight
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
  -- If a new element is highlighted, play a sound
  if old_highlight ~= highlight and highlight then
    audiomanager.new(audio.button_hovered, .6)
  end

  -- Textbox blink timer
  t = t + dt
  if t > thresh * 2 then
    t = 0
  end
end

gui.draw = function()
  -- Draw buttons
  for k, v in pairs(buttons) do
    -- Text button
    if v.text then
      if highlight == k then
        love.graphics.draw(graphics.gui.button_highlight, v.x, v.y)
      else
        love.graphics.draw(graphics.gui.button, v.x, v.y)
      end
      love.graphics.setFont(graphics.fonts.large)
      love.graphics.print(v.text, v.x + 6, v.y + 6)
    -- Icon button
    elseif v.icon then
      if highlight == k then
        love.graphics.draw(graphics.gui.icon_button_highlight, v.x, v.y)
      else
        love.graphics.draw(graphics.gui.icon_button, v.x, v.y)
      end
      love.graphics.draw(graphics.gui.button_icons, graphics.gui.button_icons_quads[v.icon], v.x + 4, v.y + 4)
    end

    --love.graphics.rectangle("line", v.x, v.y, v.w, v.h)
    --love.graphics.print(v.text, v.x, v.y)
  end
  -- Draw textboxes
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
  -- Draw texts
  for k, v in pairs(texts) do
    love.graphics.setFont(graphics.fonts.large)
    love.graphics.printf(v.text, v.x, v.y + 6, v.w, v.mode)
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
  else
    audiomanager.new(audio.button_clicked, .3)
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

gui.new_icon_button = function(id, x, y, w, h, icon, func, args)
  buttons[id] = {x = x, y = y, w = w, h = h, icon = icon, func = func, args = args}
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

gui.new_text = function(id, x, y, w, text, mode)
  texts[id] = {x = x, y = y, w = w, text = text, mode = mode}
end

gui.remove_text = function(id)
  texts[id] = nil
end

gui.remove_all = function()
  buttons = {}
  textboxes = {}
  texts = {}
end

return gui

mainmenu = require "mainmenu"
preserver = require "preserver"
preclient = require "preclient"
server = require "server"
client = require "client"
game = require "game"

local gui = require "gui"

mode = "mainmenu"

-- The canvas to draw from
canvas = false
-- The scale of the game window
scale = 2

love.load = function()
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.window.setMode(600, 800, {fullscreen=true})
  love.window.setTitle("Witchy Wizard Wars Transmuted")
  canvas = love.graphics.newCanvas(love.graphics.getWidth() / scale, love.graphics.getHeight() / scale)

  mainmenu.load()
end

love.update = function(dt)
  gui.update(dt)

  if mode == "mainmenu" then
    mainmenu.update(dt)
  elseif mode == "preserver" then
    preserver.update(dt)
  elseif mode == "preclient" then
    preclient.update(dt)
  elseif mode == "server" then
    server.update(dt)
  elseif mode == "client" then
    client.update(dt)
  end
end

love.draw = function()
  -- Switch to the main canvas
  love.graphics.setCanvas(canvas)
  -- Clear the canvas
  love.graphics.clear()

  -- Draw everything
  gui.draw()
  if mode == "mainmenu" then
    mainmenu.draw()
  elseif mode == "preserver" then
    preserver.draw()
  elseif mode == "preclient" then
    preclient.draw()
  elseif mode == "server" then
    server.draw()
  elseif mode == "client" then
    client.draw()
  end

  -- Draw the main canvas
  love.graphics.setCanvas()
  love.graphics.draw(canvas, 0, 0, 0, scale, scale)
end

love.mousepressed = function(x, y, button)
  gui.mousepressed(x, y, button)
  if mode == "server" then
    server.mousepressed(x, y, button)
  elseif mode == "client" then
    client.mousepressed(x, y, button)
  end
end

love.keypressed = function(key)
  gui.keypressed(key)
  if mode == "server" then
    server.keypressed(key)
  elseif mode == "client" then
    client.keypressed(key)
  end
end

love.textinput = function(text)
  gui.textinput(text)
end

love.quit = function()
  if mode == "preserver" then
    preserver.quit()
  elseif mode == "preclient" then
    preclient.quit()
  elseif mode == "server" then
    server.quit()
  elseif mode == "client" then
    client.quit()
  end
end

-- Returns the mouse position scaled by the scale
get_mouse_pos = function()
  local mx, my = love.mouse.getPosition()
  return mx / scale, my / scale
end

-- Returns the window width
get_window_w = function()
  return love.graphics.getWidth() / scale
end

-- Returns the window height
get_window_h = function()
  return love.graphics.getHeight() / scale
end

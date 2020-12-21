mainmenu = require "mainmenu"
preserver = require "preserver"
preclient = require "preclient"
server = require "server"
client = require "client"
game = require "game"

local gui = require "gui"


mode = "mainmenu"

love.load = function()
  love.window.setTitle("Witchy Wizard Wars Transmuted")

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
  --love.graphics.print(mode)
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

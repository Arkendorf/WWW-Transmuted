local graphics = {}

graphics.generate_quads = function(image, frames, size)
  local quads = {}
  for i = 1, frames do
    quads[i] = love.graphics.newQuad((i - 1) * size, 0, size, size, image:getDimensions())
  end
  return quads
end

graphics.images = {}
-- Cards
graphics.images.card_shield = love.graphics.newImage("images/card_shield.png")
graphics.images.card_spell = love.graphics.newImage("images/card_spell.png")
graphics.images.card_back = love.graphics.newImage("images/card_back.png")
-- tokens
graphics.images.token_empty = love.graphics.newImage("images/token_empty.png")
graphics.images.token_opponent = love.graphics.newImage("images/token_opponent.png")
graphics.images.token = love.graphics.newImage("images/token.png")
graphics.images.token_highlight = love.graphics.newImage("images/token_highlight.png")
graphics.images.token_select = love.graphics.newImage("images/token_select.png")
graphics.images.shield = love.graphics.newImage("images/shield.png")
graphics.images.spell = love.graphics.newImage("images/spell.png")
-- Characters
graphics.images.crimson_wizard = love.graphics.newImage("images/crimson_wizard.png")
graphics.images.gandalf = love.graphics.newImage("images/gandalf.png")
graphics.images.large_shield = love.graphics.newImage("images/large_shield.png")
-- attack
graphics.images.attack = love.graphics.newImage("images/attack.png")
-- Logo
graphics.images.logo = love.graphics.newImage("images/logo.png")
-- particles
-- Dust
graphics.images.dust = love.graphics.newImage("images/dust.png")
graphics.images.dust_quads = graphics.generate_quads(graphics.images.dust, 14, 32)
-- Attack trail
graphics.images.attack_trail = love.graphics.newImage("images/attack_trail.png")
graphics.images.attack_trail_quads = graphics.generate_quads(graphics.images.attack_trail, 16, 32)
-- Damage
graphics.images.damage = love.graphics.newImage("images/damage.png")
graphics.images.damage_quads = graphics.generate_quads(graphics.images.damage, 8, 32)

-- gui
graphics.gui = {}
graphics.gui.menu = love.graphics.newImage("images/menu.png")
-- Button
graphics.gui.button = love.graphics.newImage("images/button.png")
graphics.gui.button_highlight = love.graphics.newImage("images/button_highlight.png")
graphics.gui.icon_button = love.graphics.newImage("images/icon_button.png")
graphics.gui.icon_button_highlight = love.graphics.newImage("images/icon_button_highlight.png")
graphics.gui.button_icons = love.graphics.newImage("images/button_icons.png")
graphics.gui.button_icons_quads = graphics.generate_quads(graphics.gui.button_icons, 5, 16)

-- textbox
graphics.gui.textbox = love.graphics.newImage("images/textbox.png")
graphics.gui.textbox_highlight = love.graphics.newImage("images/textbox_highlight.png")
graphics.gui.textbox_selected = love.graphics.newImage("images/textbox_selected.png")

-- Fonts
graphics.fonts = {}
graphics.fonts.small = love.graphics.newImageFont("images/small_font.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
    "abcdefghijklmnopqrstuvwxyz" ..
    "0123456789!?.,:-*()", -1)
graphics.fonts.small_border = love.graphics.newImageFont("images/small_font_border.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
    "abcdefghijklmnopqrstuvwxyz" ..
    "0123456789!?.,:-*()")
graphics.fonts.large_numbers = love.graphics.newImageFont("images/large_numbers.png", "0123456789")
graphics.fonts.large = love.graphics.newImageFont("images/large_font.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
    "abcdefghijklmnopqrstuvwxyz" ..
    "0123456789!?.,:-*()/'‘’\"“”|", 1)
love.graphics.setFont(graphics.fonts.large)

return graphics

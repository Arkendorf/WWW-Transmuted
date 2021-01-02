local graphics = {}

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

graphics.images.logo = love.graphics.newImage("images/logo.png")

-- gui
graphics.gui = {}
graphics.gui.menu = love.graphics.newImage("images/menu.png")
-- Button
graphics.gui.button = love.graphics.newImage("images/button.png")
graphics.gui.button_highlight = love.graphics.newImage("images/button_highlight.png")
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

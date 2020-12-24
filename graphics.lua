local graphics = {}

graphics.images = {}
-- Cards
graphics.images.card_shield = love.graphics.newImage("images/card_shield.png")
graphics.images.card_spell = love.graphics.newImage("images/card_spell.png")
graphics.images.card_back = love.graphics.newImage("images/card_back.png")
-- tokens
graphics.images.token_empty = love.graphics.newImage("images/token_empty.png")
graphics.images.token = love.graphics.newImage("images/token.png")
graphics.images.token_highlight = love.graphics.newImage("images/token_highlight.png")
graphics.images.shield = love.graphics.newImage("images/shield.png")
graphics.images.spell = love.graphics.newImage("images/spell.png")
-- Characters
graphics.images.crimson_wizard = love.graphics.newImage("images/crimson_wizard.png")
graphics.images.gandalf = love.graphics.newImage("images/gandalf.png")

graphics.fonts = {}
graphics.fonts.small = love.graphics.newImageFont("images/small_font.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
    "abcdefghijklmnopqrstuvwxyz" ..
    "0123456789!?.,:-*()", -1)
graphics.fonts.small_border = love.graphics.newImageFont("images/small_font_border.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
    "abcdefghijklmnopqrstuvwxyz" ..
    "0123456789!?.,:-*()")
graphics.fonts.large_numbers = love.graphics.newImageFont("images/large_numbers.png", "0123456789")

return graphics

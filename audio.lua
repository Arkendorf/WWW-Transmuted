local audio = {}

audio.spell_death = love.audio.newSource("audio/spell_death.wav", "static")
audio.shield_hurt = love.audio.newSource("audio/shield_hurt.mp3", "static")
audio.shield_death = love.audio.newSource("audio/shield_death.wav", "static")
audio.gandalf_hurt = false
audio.gandalf_death = false
audio.crimson_hurt = false
audio.crimson_death = false

audio.card_hovered = love.audio.newSource("audio/card_hovered.wav", "static")
audio.card_selected = love.audio.newSource("audio/card_selected.wav", "static")
audio.token_hovered = love.audio.newSource("audio/token_hovered.mp3", "static")
audio.card_placed = love.audio.newSource("audio/card_placed.wav", "static")

audio.button_hovered = love.audio.newSource("audio/button_hovered.wav", "static")
audio.button_clicked = love.audio.newSource("audio/button_clicked.wav", "static")

audio.attack_shot = love.audio.newSource("audio/attack_shot.wav", "static")

return audio

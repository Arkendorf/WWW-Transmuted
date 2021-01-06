local audio = {}

audio.spell_death = love.audio.newSource("audio/spell_death.wav", "static")
audio.shield_hurt = love.audio.newSource("audio/shield_hurt.mp3", "static")
audio.shield_death = love.audio.newSource("audio/shield_death.wav", "static")
audio.gandalf_hurt = false
audio.gandalf_death = false
audio.crimson_hurt = false
audio.crimson_death = false

audio.card_hovered = love.audio.newSource("audio/button_hovered.wav", "static")
audio.card_selected = love.audio.newSource("audio/button_clicked.wav", "static")
audio.token_hovered = love.audio.newSource("audio/button_hovered.wav", "static")
audio.card_placed = love.audio.newSource("audio/card_placed.wav", "static")

audio.card_draw = love.audio.newSource("audio/card_draw.wav", "static")

audio.button_hovered = love.audio.newSource("audio/button_hovered.wav", "static")
audio.button_clicked = love.audio.newSource("audio/button_clicked.wav", "static")

audio.attack_shot = love.audio.newSource("audio/attack_shot.wav", "static")

audio.crimson_hurts = {
  love.audio.newSource("audio/crimson_hurt1.mp3", "static"),
  love.audio.newSource("audio/crimson_hurt2.mp3", "static"),
  love.audio.newSource("audio/crimson_hurt3.mp3", "static"),
}
audio.crimson_death = love.audio.newSource("audio/crimson_death.mp3", "static")

audio.gandalf_hurts = {
  love.audio.newSource("audio/gandalf_hurt1.mp3", "static"),
  love.audio.newSource("audio/gandalf_hurt2.mp3", "static"),
  love.audio.newSource("audio/gandalf_hurt3.mp3", "static"),
}
audio.gandalf_death = love.audio.newSource("audio/gandalf_death.mp3", "static")



audio.title = love.audio.newSource("audio/title.mp3", "stream")
audio.title_volume = .05
audio.title:setVolume(audio.title_volume)
audio.title:isLooping(true)

audio.bgm = love.audio.newSource("audio/bgm.mp3", "stream")
audio.bgm_volume = .02
audio.bgm:setVolume(audio.bgm_volume)
audio.bgm:isLooping(true)

return audio

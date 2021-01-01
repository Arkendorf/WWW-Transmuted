local cards = {}

cards[1] = {
  name = "Common Bullet",
  type = "spells",
  value = 1,
  image = love.graphics.newImage("images/cards/common_bullet.png"),
}

cards[2] = {
  name = "Brick Wall",
  type = "shields",
  value = 3,
  image = love.graphics.newImage("images/cards/brick_wall.png"),
}

cards[3] = {
  name = "Man of Steel",
  type = "shields",
  value = 2,
  image = love.graphics.newImage("images/cards/man_of_steel.png"),
}

cards[4] = {
  name = "Navy Plane",
  type = "spells",
  value = 2,
  image = love.graphics.newImage("images/cards/navy_plane.png"),
}

cards[5] = {
  name = "Radioactive Bullet",
  type = "spells",
  value = 2,
  image = love.graphics.newImage("images/cards/radioactive_bullet.png"),
}

cards[6] = {
  name = "Boom Boom Pow",
  type = "spells",
  value = 3,
  image = love.graphics.newImage("images/cards/boom_boom_pow.png"),
}

cards[7] = {
  name = "King Kong",
  type = "spells",
  value = 3,
  image = love.graphics.newImage("images/cards/king_kong.png"),
}

cards[8] = {
  name = "Castle Gates",
  type = "shields",
  value = 2,
  image = love.graphics.newImage("images/cards/castle_gates.png"),
}

cards[9] = {
  name = "Attack",
  type = "spells",
  value = 1,
  image = love.graphics.newImage("images/cards/attack.png"),
}

cards[10] = {
  name = "Superman",
  type = "shields",
  value = 2,
  image = love.graphics.newImage("images/cards/superman.png"),
}

cards[11] = {
  name = "Sword",
  type = "spells",
  value = 2,
  image = love.graphics.newImage("images/cards/sword.png"),
}

cards[12] = {
  name = "Armor",
  type = "shields",
  value = 3,
  image = love.graphics.newImage("images/cards/armor.png"),
}

cards[13] = {
  name = "Parachute",
  type = "spells",
  value = 2,
  image = love.graphics.newImage("images/cards/parachute.png"),
}

cards[14] = {
  name = "Shield",
  type = "shields",
  value = 2,
  image = love.graphics.newImage("images/cards/shield.png"),
}

cards[15] = {
  name = "Zuko",
  type = "spells",
  value = 3,
  image = love.graphics.newImage("images/cards/zuko.png"),
}

cards[16] = {
  name = "Automatic stopper",
  type = "shields",
  value = 2,
}

cards[17] = {
  name = "Poison Fingernails",
  type = "spells",
  value = 3,
}

cards[18] = {
  name = "Force Field",
  type = "shields",
  value = 3,
}

cards[19] = {
  name = "Invisible Wall",
  type = "shields",
  value = 2,
}

-- Give each card a reference to it's number
for i, card in ipairs(cards) do
  card.num = i
end

return cards

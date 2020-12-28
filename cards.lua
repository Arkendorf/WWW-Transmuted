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
}

cards[5] = {
  name = "Radioactive Bullet",
  type = "spells",
  value = 2,
}

cards[6] = {
  name = "Boom Boom Pow",
  type = "spells",
  value = 3,
}

cards[7] = {
  name = "King Kong",
  type = "spells",
  value = 3,
}

cards[8] = {
  name = "Castle Gates",
  type = "shields",
  value = 2,
}

cards[9] = {
  name = "Attack!",
  type = "spells",
  value = 1,
}

cards[10] = {
  name = "Superman",
  type = "shields",
  value = 2,
}

cards[11] = {
  name = "Sword",
  type = "spells",
  value = 2,
}

cards[12] = {
  name = "Armor",
  type = "shields",
  value = 3,
}

cards[13] = {
  name = "Parashute",
  type = "spells",
  value = 2,
}

cards[14] = {
  name = "Shield!",
  type = "shields",
  value = 2,
}

cards[15] = {
  name = "Zuko",
  type = "spells",
  value = 3,
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
  name = "Force Field!",
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

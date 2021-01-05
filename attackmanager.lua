local graphics = require "graphics"
local particlemanager = require "particlemanager"

local attackmanager = {}

-- List of attack projectiles
attackmanager.attacks = {}
-- Attack projectile speed
attackmanager.attack_speed = 500

-- Shake magnitude
attackmanager.shake_mag = 4

-- How many seconds to wait between each trail particle spawn
attackmanager.trail_t = .03

attackmanager.load = function()
  attackmanager.t = 0
  attackmanager.attacks = {}
end

attackmanager.update = function(dt)
  -- Keep track of time
  attackmanager.t = attackmanager.t + dt

  -- Iterate backwards through attacks
  for i = #attackmanager.attacks, 1, -1 do
    -- Get the current attack
    attack = attackmanager.attacks[i]
    -- Move the attack
    attack.x = attack.x + attack.dir * attackmanager.attack_speed * dt

    -- Spawn attack trail particles
    if attackmanager.t >= attackmanager.trail_t then
      particlemanager.new("attack", attack.x, attack.y)
    end

    -- Check if attack reached it's destination
    if attack.x * attack.dir >= attack.goal_x * attack.dir then
      -- Remove health from target
      if attack.target.type == "spells" then
        attack.target.value = 0
        attack.target.shake = .2
      else
        attack.target.value = attack.target.value - attack.value
        attack.target.shake = .1 * attack.value
      end

      -- Play damage particles
      for i = 1, 8 do
        particlemanager.new("damage", attack.goal_x, attack.y)
      end

      -- Remove attack
      table.remove(attackmanager.attacks, i)
    end
  end

  -- Reset timer
  if attackmanager.t > attackmanager.trail_t then
    attackmanager.t = attackmanager.t - attackmanager.trail_t
  end
end

attackmanager.draw = function()
  for i, attack in ipairs(attackmanager.attacks) do
    love.graphics.draw(graphics.images.attack, math.floor(attack.x), math.floor(attack.y), 0, 1, 1, 17, 17)
  end
end

attackmanager.add_attack = function(caster, target, start_x, goal_x, y)
  local dir = 1
  if goal_x - start_x < 0 then
    dir = -1
  end
  table.insert(attackmanager.attacks, {value = caster.value, target = target, x = start_x, goal_x = goal_x, y = y, dir = dir})
end

attackmanager.attacks_over = function()
  return #attackmanager.attacks <= 0
end

return attackmanager

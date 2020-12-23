local attackmanager = {}

-- List of attack projectiles
attackmanager.attacks = {}
-- Attack projectile speed
attackmanager.attack_speed = 500;

attackmanager.load = function()
  attackmanager.attacks = {}
end

attackmanager.update = function(dt)
  -- Iterate backwards through attacks
  for i = #attackmanager.attacks, 1, -1 do
    -- Get the current attack
    attack = attackmanager.attacks[i]
    -- Move the attack
    attack.x = attack.x + attack.dir * attackmanager.attack_speed * dt
    -- Check if attack reached it's destination
    if attack.x * attack.dir >= attack.goal_x * attack.dir then
      if attack.target.type == "spells" then
        attack.target.value = 0
      else
        attack.target.value = attack.target.value - attack.value
      end
      table.remove(attackmanager.attacks, i)
    end
  end
end

attackmanager.draw = function()
  for i, attack in ipairs(attackmanager.attacks) do
    love.graphics.circle("fill", attack.x, attack.y, 30, 30)
  end
end

attackmanager.add_attack = function(caster, target, start_x, goal_x, y)
  local dir = 1
  if goal_x - start_x < 0 then
    dir = -1
  end
  table.insert(attackmanager.attacks, {value = caster.value, target = target, x = start_x, goal_x = goal_x, y = y, dir = dir})
end

return attackmanager

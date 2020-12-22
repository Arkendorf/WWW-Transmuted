local attackmanager = {}

attackmanager.attacks = {}
attackmanager.attack_speed = 120;

attackmanager.load = function()
  attackmanager.attacks = {}
end

attackmanager.update = function(dt)
  for i = #attackmanager.attacks, 1, -1 do
    attack = attackmanager.attacks[i]
    attack.y = attack.y + attack.dir * attackmanager.attack_speed * dt
    if attack.y * attack.dir >= attack.goal_y * attack.dir then
      attack.target.value = attack.target.value - attack.value
      table.remove(attackmanager.attacks, i)
    end
  end
end

attackmanager.draw = function()
  for i, attack in ipairs(attackmanager.attacks) do
    love.graphics.circle("fill", attack.x, attack.y, 30, 30)
  end
end

attackmanager.add_attack = function(caster, target, x, start_y, goal_y)
  local dir = 1
  if goal_y - start_y < 0 then
    dir = -1
  end
  table.insert(attackmanager.attacks, {value = caster.value, target = target, x = x, y = start_y, goal_y = goal_y, dir = dir})
end

return attackmanager

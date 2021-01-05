local particles = require "particles"

local particlemanager = {}

-- The list of particles currently being rendered
particlemanager.particles = {}

particlemanager.load = function()
  -- Reset list of particles
  particlemanager.particles = {}
end

particlemanager.update = function(dt)
  -- Iterate through each particle
  for i = #particlemanager.particles, 1, -1 do
    -- Get the current particle
    local particle = particlemanager.particles[i]

    -- Update the current particle using the update function of its type
    if particles[particle.type].update(particle, dt) then
      -- If update func returned true, delete this particle
      table.remove(particlemanager.particles, i)
    end
  end
end

particlemanager.draw = function()
  -- Iterate through each particle
  for i, particle in ipairs(particlemanager.particles) do
    -- Draw each particle using its type's draw function
    particles[particle.type].draw(particle)
  end
end

-- Creates a new particle
particlemanager.new = function(type, x, y, data)
  -- Create the basic particle object
  local particle = {type = type, x = x, y = y, data = data}
  -- Call the load function of the particle's type
  particles[particle.type].load(particle)
  -- Add the new particle to the list of particles
  table.insert(particlemanager.particles, particle)
end


return particlemanager

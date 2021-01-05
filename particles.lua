local graphics = require "graphics"

local particles = {}

-- Dust particle
particles.dust = {
  lifetime = .8,
  frames = 14,
  -- Called once when the particle is created
  load = function(particle)
    particle.t = particles.dust.lifetime
    -- Pick a random angle to move the particle in the direction of
    local angle = math.random(0, 200 * math.pi) / 100
    particle.xv = math.cos(angle)
    particle.yv = math.sin(angle)
  end,
  -- Called every frame
  update = function(particle, dt)
    -- Manager particle lifetime
    if particle.t > 0 then
      particle.t = particle.t - dt
    end
    -- If particle has expired, return true (so it is deleted)
    if particle.t <= 0 then
      return true
    end

    -- Move the particle by the velocity
    particle.x = particle.x + particle.xv * dt * 60 * 6
    particle.y = particle.y + particle.yv * dt * 60 * 6
    -- Reduce velocity
    particle.xv = particle.xv * .9
    particle.yv = particle.yv * .9
  end,
  -- Called to render the particle to the screen
  draw = function(particle)
    local frame = particles.dust.frames - math.floor(particle.t / particles.dust.lifetime * particles.dust.frames)
    love.graphics.draw(graphics.images.dust, graphics.images.dust_quads[frame], math.floor(particle.x), math.floor(particle.y), 0, 1, 1, 16, 16)
  end,
}

return particles
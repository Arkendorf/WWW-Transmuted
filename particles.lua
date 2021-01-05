local particles = {}

-- Dust particle
particles.dust = {
  -- Called once when the particle is created
  load = function(particle)
    particle.t = .5
    particle.xv = math.random(-100, 100) / 100
    particle.yv = math.random(-100, 100) / 100
  end,
  -- Called every frame
  update = function(particle, dt)
    -- Manager particle lifetime
    if particle.t > 0 then
      particle.t = particle.t - dt
    else -- If particle has expired, return true
      return true
    end

    -- Move the particle by the velocity
    particle.x = particle.x + particle.xv * dt * 60 * 4
    particle.y = particle.y + particle.yv * dt * 60 * 4
    -- Reduce velocity
    particle.xv = particle.xv * .96
    particle.yv = particle.yv * .96
  end,
  -- Called to render the particle to the screen
  draw = function(particle)
    love.graphics.circle("fill", math.floor(particle.x), math.floor(particle.y), (particle.t / .5) * 30, 30)
  end,
}

return particles

local audiomanager = {}

audiomanager.sources = {}

audiomanager.load = function()
  audiomanager.sources = {}
end

audiomanager.update = function(dt)
  for i = #audiomanager.sources, 1, -1 do
    local source = audiomanager.sources[i]

    if not source:isPlaying() then
      table.remove(audiomanager.sources, i)
      source:release()
    end
  end
end

audiomanager.new = function(source, volume)
  local clone = source:clone()
  audiomanager.format(clone, volume)
  table.insert(audiomanager.sources, clone)
  clone:setLooping(false)
  clone:play()
end

audiomanager.play = function(source, volume)
  audiomanager.format(source, volume)
  source:seek(0)
  source:play()
end

audiomanager.format = function(source, volume)
  source:setVolume(volume or 1)
end

return audiomanager

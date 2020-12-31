local palettes = {}

-- White and black
palettes[1] = {
  light = {255, 255, 255, 255},
  dark = {0, 0, 0, 255},
}

-- Red and black
palettes[2] = {
  light = {255, 0, 0, 255},
  dark = {0, 0, 0, 255},
}

-- Green and black
palettes[3] = {
  light = {0, 255, 0, 255},
  dark = {0, 0, 0, 255},
}

-- Blue and black
palettes[4] = {
  light = {0, 0, 255, 255},
  dark = {0, 0, 0, 255},
}

-- Yellow and black
palettes[5] = {
  light = {255, 255, 0, 255},
  dark = {0, 0, 0, 255},
}

-- Cyan and black
palettes[6] = {
  light = {0, 255, 255, 255},
  dark = {0, 0, 0, 255},
}

-- Magenta and black
palettes[7] = {
  light = {255, 0, 255, 255},
  dark = {0, 0, 0, 255},
}

-- https://lospec.com/palette-list/obra-dinn-ibm-8503
palettes[8] = {
  light = {235, 229, 206, 255},
  dark = {46, 48, 55, 255},
}

-- https://lospec.com/palette-list/obra-dinn-zenith-zvm-1240
palettes[9] = {
  light = {253, 202, 85, 255},
  dark = {63, 41, 30, 255},
}

-- https://lospec.com/palette-list/obra-dinn-zenith-zvm-1240
palettes[10] = {
  light = {1, 235, 95, 255},
  dark = {37, 52, 47, 255},
}

-- https://lospec.com/palette-list/obra-dinn-macintosh
palettes[11] = {
  light = {229, 255, 255, 255},
  dark = {51, 51, 25, 255},
}

-- https://lospec.com/palette-list/pixel-ink
palettes[11] = {
  light = {237, 246, 214, 255},
  dark = {62, 35, 44, 255},
}

-- https://lospec.com/palette-list/paperback-2
palettes[12] = {
  light = {184, 194, 185, 255},
  dark = {56, 43, 38, 255},
}

-- https://lospec.com/palette-list/noire-truth
palettes[13] = {
  light = {198, 186, 172, 255},
  dark = {30, 28, 50, 255},
}

-- https://lospec.com/palette-list/gato-roboto-urine
palettes[14] = {
  light = {255, 213, 0, 255},
  dark = {0, 47, 64, 255},
}

-- https://lospec.com/palette-list/gato-roboto-swamp-matcha
palettes[15] = {
  light = {204, 220, 162, 255},
  dark = {16, 55, 14, 255},
}


-- Change colors from range 0-255 to range 0-1
for i, palette in ipairs(palettes) do
  for type, color in pairs(palette) do
    for j, channel in ipairs(color) do
      palettes[i][type][j] = palettes[i][type][j] / 255
    end
  end
end

return palettes

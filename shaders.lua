local shaders = {}

shaders.palette = love.graphics.newShader([[
    extern vec4 light = vec4(1, 1, 1, 1);
    extern vec4 dark = vec4(0, 0, 0, 1);
    vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
    {
      // Get the color of the current pixel
      vec4 texcolor = Texel(tex, texture_coords);
      // Calculate its average brightness
      float avg = (texcolor.r + texcolor.g + texcolor.b) / 3.0;

      // 1 if color is light, 0 if color is dark
      float percent = floor(avg + 0.5);

      // col is now either the light or dark color
      vec4 col = percent * light + (1.0 - percent) * dark;
      // Set the alpha to match the alpha of the original pixel
      col.a = texcolor.a;
      // Return the new color;
      return col;
    }
]])

return shaders

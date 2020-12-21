local handmanager = require "handmanager"

boardmanager = {}

-- Player's board info
boardmanager.player_board = {
  spells = {},
  shields = {},
}

-- Opponent's board info
boardmanager.opponent_board = {
  spells = {},
  shields = {},
}

-- Number of lanes on the board
boardmanager.lane_num = 3

-- Size of board tokens
boardmanager.token_w = 100
boardmanager.token_h = 100

-- Graphics info for player's board
boardmanager.player_graphics = {
  x = (love.graphics.getWidth() - boardmanager.token_w * boardmanager.lane_num) / 2,
  y = love.graphics.getHeight() / 2,
  top = "shields"
}

-- Graphics info for opponent's board
boardmanager.opponent_graphics = {
  x = boardmanager.player_graphics.x,
  y = love.graphics.getHeight() / 2 - boardmanager.token_h * 2,
  top = "spells"
}

boardmanager.hover = false

boardmanager.load = function()
  -- Reset boards to default state
  for _, board in ipairs({boardmanager.player_board, boardmanager.opponent_board}) do
    for i = 1, boardmanager.lane_num do
      board.spells[i] = false
      board.shields[i] = false
    end
  end
end

boardmanager.update = function(dt)
  -- Reset the hover
  boardmanager.hover = false
  -- Get the mouse position
  local mx, my = love.mouse.getPosition()
  -- Iterate through the rows in the board
  for type, row in pairs(boardmanager.player_board) do
    -- If the row matches the type of the currently selected card then allow hovering
    if handmanager.selected and handmanager.hand[handmanager.selected].type == type then
      -- Iterate through each space in the row
      for lane, card in ipairs(row) do
        -- Get the space's position
        local x, y = boardmanager.get_space_coords(lane, type, boardmanager.player_graphics)
        if mx > x and mx < x + boardmanager.token_w and my > y and my < y + boardmanager.token_h then
          boardmanager.hover = lane
        end
      end
    end
  end

  if handmanager.grabbed and not love.mouse.isDown(1) then
    boardmanager.place_card()
  end
end

boardmanager.mousepressed = function(x, y, button)
  if button == 1 then
    boardmanager.place_card()
  end
end

boardmanager.place_card = function()
  -- Make sure that a valid place is selected
  if boardmanager.hover then
    -- Get the selected card
    local selected_card = handmanager.hand[handmanager.selected]
    -- Put the card into the place
    boardmanager.player_board[selected_card.type][boardmanager.hover] = selected_card
    -- Tell the hand manager that the card was placed
    handmanager.card_placed()
    -- Let whoever's handling the network know
    boardmanager.network_card_placed()
  end
end

-- This function will be overridden by either the client or server
boardmanager.network_card_placed = function()
end

boardmanager.draw = function()
  boardmanager.draw_board(boardmanager.opponent_board, boardmanager.opponent_graphics)
  boardmanager.draw_board(boardmanager.player_board, boardmanager.player_graphics, true)
end

-- Draw a board
boardmanager.draw_board = function(board, graphics_data, editable)
  for type, row in pairs(board) do
    for lane, card in ipairs(row) do
      boardmanager.draw_space(card, lane, type, graphics_data, editable)
    end
  end
end

-- Draw a single space on a board
boardmanager.draw_space = function(card, lane, type, graphics_data, editable)
  -- Convert data to the position of the space
  local x, y = boardmanager.get_space_coords(lane, type, graphics_data)
  -- Draw the space's outline
  -- If the board is the local players, highlight spaces where the selected card can be placed
  if editable and handmanager.selected and handmanager.hand[handmanager.selected].type == type then
    love.graphics.rectangle("fill", x, y, boardmanager.token_h, boardmanager.token_w)
  else
    love.graphics.rectangle("line", x, y, boardmanager.token_h, boardmanager.token_w)
  end
  -- Draw the card token in the space
  if card then
    boardmanager.draw_token(card, x, y)
  end
end

-- Get the screen position of a space
boardmanager.get_space_coords = function(lane, type, graphics_data)
  local x = graphics_data.x + (lane - 1) * boardmanager.token_w
  local y = graphics_data.y
  if type ~= graphics_data.top then
    y = y + boardmanager.token_h
  end
  return x, y
end

-- Draws a token based on the given card
boardmanager.draw_token = function(card, x, y)
  love.graphics.rectangle("line", x, y, boardmanager.token_h, boardmanager.token_w)
  love.graphics.print(card.value, x, y)
end

return boardmanager

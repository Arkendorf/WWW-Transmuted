local handmanager = require "handmanager"
local attackmanager = require "attackmanager"
local charmanager = require "charmanager"

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
  x = love.graphics.getWidth() / 2 - boardmanager.token_h * 2,
  y = (love.graphics.getHeight() - boardmanager.token_w * boardmanager.lane_num) / 2,
  top = "spells"
}

-- Graphics info for opponent's board
boardmanager.opponent_graphics = {
  x = love.graphics.getWidth() / 2,
  y = boardmanager.player_graphics.y,
  top = "shields"
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
  boardmanager.check_death(boardmanager.player_board)
  boardmanager.check_death(boardmanager.opponent_board)

  -- Reset the hover
  boardmanager.hover = false
  -- Get the mouse position
  local mx, my = love.mouse.getPosition()
  -- Iterate through the rows in the board
  for type, row in pairs(boardmanager.player_board) do
    -- If the row matches the type of the currently selected card then allow hovering
    if handmanager.selected and handmanager.hand[handmanager.selected].type == type then
      -- Iterate through each space in the row
      for lane, token in ipairs(row) do
        -- Get the space's position
        local x, y = boardmanager.get_space_coords(lane, type, boardmanager.player_graphics)
        if mx > x and mx < x + boardmanager.token_w and my > y and my < y + boardmanager.token_h then
          boardmanager.hover = lane
        end
      end
    end
  end

  -- If the player has grabbed a card, and dropped it, try to place it
  if handmanager.grabbed and not love.mouse.isDown(1) then
    boardmanager.place_player_card()
  end

  -- If both the player and the opponent have placed their cards, move on to the next part of the game
  if game.opponent_placed and game.opponent_turn.card then
    -- Place the opponent's card visually on the board
    boardmanager.place_card(boardmanager.opponent_board, game.opponent_turn.card, game.opponent_turn.lane)
    -- Reset opponent card after it has been added
    game.opponent_placed = false
    game.opponent_turn.card = false
    -- Reset player card after it has been added
    game.placed_placed = false
    game.player_turn.card = false
    -- Move on to the next game state
    game.state = "simulate"
    -- Generate attacks
    boardmanager.generate_attacks(boardmanager.player_board, boardmanager.opponent_board, boardmanager.player_graphics, boardmanager.opponent_graphics, charmanager.opponent)
    boardmanager.generate_attacks(boardmanager.opponent_board, boardmanager.player_board, boardmanager.opponent_graphics, boardmanager.player_graphics, charmanager.player)
  end

  if game.state == "simulate" and #attackmanager.attacks <= 0 then
    game.state = "place"
  end
end

-- Checks if tokens have died
boardmanager.check_death = function(board)
  -- Iterate through the rows of the board
  for type, row in pairs(board) do
    -- Iterate through the lanes on that row
    for lane, token in ipairs(row) do
      -- If the token exists and it's value is less than or equal to zero, remove it
      if token and token.value <= 0 then
        board[type][lane] = false
      end
    end
  end
end

boardmanager.generate_attacks = function(player_board, opponent_board, player_graphics, opponent_graphics, opponent_char)
  -- Iterate through the spellcasting lanes
  for lane, token in ipairs(player_board.spells) do
    -- Check if the spot is occupied
    if token then
      -- Determine the attack's target. The opponent, the shield, or the spell
      local target = opponent_char -- default should be enemy player
      local goal_x = opponent_char.x
      if opponent_board.shields[lane] then
        target = opponent_board.shields[lane]
        goal_x = boardmanager.get_space_coords(lane, "shields", opponent_graphics) + boardmanager.token_w / 2
      elseif opponent_board.spells[lane] then
        target = opponent_board.spells[lane]
        goal_x = boardmanager.get_space_coords(lane, "spells", opponent_graphics) + boardmanager.token_w / 2
      end
      -- Get the spell's position
      local x, y = boardmanager.get_space_coords(lane, "spells", player_graphics)
      -- Create the attack
      attackmanager.add_attack(token, target, x + boardmanager.token_w / 2, goal_x, y + boardmanager.token_h / 2)
    end
  end
end

boardmanager.mousepressed = function(x, y, button)
  if game.state == "place" then
    if button == 1 then
      boardmanager.place_player_card()
    end
  end
end

-- Places the card the player is currently holding in the selected lane
boardmanager.place_player_card = function()
  -- Make sure that a valid place is selected
  if boardmanager.hover then
    -- Get the selected card
    local selected_card = handmanager.hand[handmanager.selected]
    -- Put the card into the place
    boardmanager.place_card(boardmanager.player_board, selected_card, boardmanager.hover)
    -- Tell the hand manager that the selected card was placed
    handmanager.card_placed()
    -- Let whoever's handling the network know that the player has placed their card
    boardmanager.network_card_placed(selected_card, boardmanager.hover, selected_card.type)
  end
end

-- Puts the given card on the given board on the given lane
boardmanager.place_card = function(board, card, lane)
  board[card.type][lane] = {value = card.value, type = card.type, card = card}
end

-- This function will be overridden by either the client or server
boardmanager.network_card_placed = function(card, lane, type)
end

boardmanager.draw = function()
  boardmanager.draw_board(boardmanager.opponent_board, boardmanager.opponent_graphics)
  boardmanager.draw_board(boardmanager.player_board, boardmanager.player_graphics, true)
end

-- Draw a board
boardmanager.draw_board = function(board, graphics_data, editable)
  for type, row in pairs(board) do
    for lane, token in ipairs(row) do
      boardmanager.draw_space(token, lane, type, graphics_data, editable)
    end
  end
end

-- Draw a single space on a board
boardmanager.draw_space = function(token, lane, type, graphics_data, editable)
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
  if token then
    boardmanager.draw_token(token, x, y)
  end
end

-- Get the screen position of a space
boardmanager.get_space_coords = function(lane, type, graphics_data)
  local x = graphics_data.x
  if type ~= graphics_data.top then
    x = x + boardmanager.token_w
  end
  local y = graphics_data.y + (lane - 1) * boardmanager.token_h
  return x, y
end

-- Draws a token based on the given card
boardmanager.draw_token = function(token, x, y)
  love.graphics.rectangle("line", x, y, boardmanager.token_h, boardmanager.token_w)
  love.graphics.print(token.value, x, y)
end

return boardmanager

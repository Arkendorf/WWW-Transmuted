local handmanager = require "handmanager"
local deckmanager = require "deckmanager"
local attackmanager = require "attackmanager"
local charmanager = require "charmanager"
local cards = require "cards"
local graphics = require "graphics"

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
boardmanager.token_w = 88
boardmanager.token_h = 88

-- space between boards
boardmanager.board_spacing = 32

-- Graphics info for player's board
boardmanager.player_graphics = {
  top = "spells",
  editable = true,
}

-- Graphics info for opponent's board
boardmanager.opponent_graphics = {
  top = "shields",
  editable = false,
}

-- How much the token should dip when placed
boardmanager.place_dip = 2
boardmanager.dip_speed = 16

boardmanager.hover = false

boardmanager.load = function()
  -- Determine player board position
  boardmanager.player_graphics.x = (get_window_w() - boardmanager.board_spacing) / 2 - boardmanager.token_h * 2
  boardmanager.player_graphics.y = (get_window_h() - deckmanager.card_h - boardmanager.token_w * boardmanager.lane_num) / 2

  -- Determine opponent board position
  boardmanager.opponent_graphics.x = (get_window_w() + boardmanager.board_spacing) / 2
  boardmanager.opponent_graphics.y = boardmanager.player_graphics.y

  -- Reset boards to default state
  for _, board in ipairs({boardmanager.player_board, boardmanager.opponent_board}) do
    for i = 1, boardmanager.lane_num do
      board.spells[i] = false
      board.shields[i] = false
    end
  end
end

boardmanager.update = function(dt)
  boardmanager.update_board(boardmanager.player_board, dt)
  boardmanager.update_board(boardmanager.opponent_board, dt)

  -- Reset the hover
  boardmanager.hover = false
  -- Get the mouse position
  local mx, my = get_mouse_pos()
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
  if (game.opponent_placed and game.opponent_turn.card_num)
    -- If player and opponent are out of cards, continue to simulate until someone dies
    or (game.state == "place" and game.player_out and game.opponent_out and charmanager.player.value > 0 and charmanager.opponent.value > 0) then

    if game.opponent_turn.card_num then
      -- Place the opponent's card visually on the board
      boardmanager.place_card(boardmanager.opponent_board, cards[game.opponent_turn.card_num], game.opponent_turn.lane)
      -- Reset opponent card after it has been added
      game.opponent_placed = false
      game.opponent_turn.card_num = false
      -- Reset player card after it has been added
      game.placed_placed = false
      game.player_turn.card_num = false
    end
    -- Move on to the next game state
    game.state = "simulate"
    -- Generate attacks
    boardmanager.generate_attacks(boardmanager.player_board, boardmanager.opponent_board, boardmanager.player_graphics, boardmanager.opponent_graphics, charmanager.opponent)
    boardmanager.generate_attacks(boardmanager.opponent_board, boardmanager.player_board, boardmanager.opponent_graphics, boardmanager.player_graphics, charmanager.player)
  end

  if game.state == "simulate" and #attackmanager.attacks <= 0 then
    game.state = "place"
  end

  -- Check if player is out of cards
  if #handmanager.hand <= 0 then
    if not game.player_out then
      -- Let opponent know that player is out
      game.player_out = true
      game.queue("out")
    elseif game.player_out and game.opponent_out then -- If both player and opponent are out of cards, and there no active spells, tie game
      -- Check for active spells
      local out = true
      for i, board in ipairs({boardmanager.player_board, boardmanager.opponent_board}) do
        for lane, token in ipairs(board.spells) do
          if token then
            out = false
            break
          end
        end
      end
      -- No more spells are active, end the game in a tie
      if out then
        game.tie_out()
      end
    end
  end
end

-- Checks if tokens have died
boardmanager.update_board = function(board, dt)
  -- Iterate through the rows of the board
  for type, row in pairs(board) do
    -- Iterate through the lanes on that row
    for lane, token in ipairs(row) do
      if token then
        -- Don't kill it if it is still shaking
        -- it's value is less than or equal to zero, remove it
        if token.shake and token.shake > 0 then
          token.shake = token.shake - dt
        elseif token.value <= 0 then
          board[type][lane] = false
        end
        -- If token is dipping, control the dip
        if token.y > 0 or token.dip > 0 then
          token.y = token.y + token.dip
          token.dip = token.dip - dt * boardmanager.dip_speed
        else -- Reset the dip
          token.y = 0
          token.dip = 0
        end
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
      local goal_x = opponent_char.x + charmanager.char_w / 2
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

    boardmanager.hover = false
  end
end

-- Puts the given card on the given board on the given lane
boardmanager.place_card = function(board, card, lane)
  board[card.type][lane] = {value = card.value, type = card.type, card = card, y = 0, dip = boardmanager.place_dip}
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
  local shake_x, shake_y = boardmanager.get_space_coords(lane, type, graphics_data)
  -- Add shake if it is shaking
  if token then
    if token.shake and token.shake > 0 then
      shake_x = shake_x + math.random(-attackmanager.shake_mag, attackmanager.shake_mag)
      shake_y = shake_y + math.random(-attackmanager.shake_mag, attackmanager.shake_mag)
    end
    -- Add dip offset
    shake_y = shake_y + token.y
  end
  -- Draw the space backing
  if graphics_data.editable then
    love.graphics.draw(graphics.images.token_empty, shake_x, shake_y)
  else
    love.graphics.draw(graphics.images.token_opponent, shake_x, shake_y)
  end
  -- Draw the card token in the space
  if token then
    boardmanager.draw_token(token, x, y, shake_x, shake_y)
  end
  -- If the board is the local players, highlight spaces where the selected card can be placed
  if editable and handmanager.selected and handmanager.hand[handmanager.selected].type == type then
    if boardmanager.hover and boardmanager.hover == lane then
      love.graphics.draw(graphics.images.token_select, x, y)
    else
      love.graphics.draw(graphics.images.token_highlight, x, y)
    end
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
boardmanager.draw_token = function(token, x, y, shake_x, shake_y)
  -- Draw token base
  love.graphics.draw(graphics.images.token, shake_x, shake_y)
  -- Draw the token image
  if token.card.image then
    love.graphics.draw(token.card.image, shake_x, shake_y)
  end
  -- Draw token type
  if token.type == "shields" then
    love.graphics.draw(graphics.images.shield, x + (boardmanager.token_w - 34) / 2, y + (boardmanager.token_h - 34) / 2)
  else
    love.graphics.draw(graphics.images.spell, x + (boardmanager.token_w - 34) / 2, y + (boardmanager.token_h - 34) / 2)
  end
  -- Draw token value
  love.graphics.setFont(graphics.fonts.large_numbers)
  love.graphics.printf(math.max(token.value, 0), x, y + 37, boardmanager.token_w, "center")

end

return boardmanager

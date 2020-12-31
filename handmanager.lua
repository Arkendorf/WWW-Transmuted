local deckmanager = require "deckmanager"
local graphics = require "graphics"

local handmanager = {}

-- The current hand of cards
handmanager.hand = {}
-- The amount of cards that should be in a hand
handmanager.hand_size = 5

handmanager.hover = false
handmanager.selected = false
handmanager.grabbed = false
local hold_time = 0
local time_to_grab = .1

-- The graphical representations of the cards in the hand
handmanager.hand_graphics = {}

handmanager.load = function()
  -- Reset hand and graphics
  handmanager.hand_graphics = {}
  handmanager.hand = {}
  
  handmanager.fill_hand(deckmanager.deck)
end

handmanager.update = function(dt)
  -- Check if the player is grabbing a card
  if handmanager.selected and love.mouse.isDown(1) then
    -- If mouse is still down on a card, increase the hold time
    hold_time = hold_time + dt
    -- If the hold time is above the threshold, mark the card as grabbed
    if hold_time > time_to_grab then
      handmanager.grabbed = handmanager.selected
    end
  end
  -- Check if the player has dropped the card
  if handmanager.grabbed and not love.mouse.isDown(1) then
    handmanager.grabbed = false
    -- Place it on board here (when that stuff is sorted)
  end

  -- Reset card hover
  handmanager.hover = false
  -- Update hand graphics
  for i, graphic in ipairs(handmanager.hand_graphics) do
    -- Check to see if the card is hovered over
    local mx, my = get_mouse_pos()
    if mx > graphic.x and mx < graphic.x + deckmanager.card_w and my > graphic.y and my < graphic.y + deckmanager.card_h then
      -- mark this card as hovered over
      handmanager.hover = i
    end

    -- Find the goal position for the current card graphic
    local goal_x
    local goal_y
    -- If the card is grabbed, move it to the mouse
    if handmanager.grabbed == i then
      goal_x = mx - deckmanager.card_w / 2
      goal_y = my - deckmanager.card_h / 2
    else -- Otherwise, put it at the right position on the bottom of the screen
      goal_x = (get_window_w() - #handmanager.hand * deckmanager.card_w) / 2 + (i-1) * deckmanager.card_w
      goal_y = get_window_h() - deckmanager.card_h
      -- Move the card up a bit if it is selected or hovered over
      if handmanager.selected == i then
        goal_y = goal_y - 24
      elseif handmanager.hover == i then
        goal_y = goal_y - 8
      end
    end
    -- Move the card towards the goal position
    graphic.x = graphic.x + (goal_x - graphic.x) * 6 * dt
    graphic.y = graphic.y + (goal_y - graphic.y) * 6 * dt
  end
end

handmanager.draw = function(dt)
  for i, graphic in ipairs(handmanager.hand_graphics) do
    handmanager.draw_card(graphic)
  end
end

-- Draws a card based on the given graphic info
handmanager.draw_card = function(graphic)
  -- Floor x and y position
  local x, y = math.floor(graphic.x), math.floor(graphic.y)
  -- Draw the card graphic
  if graphic.card.image then
    love.graphics.draw(graphic.card.image, x + 5, y + 6)
  end
  -- Use the correct card base depending on the type
  if graphic.card.type == "shields" then
    love.graphics.draw(graphics.images.card_shield, x, y)
  else
    love.graphics.draw(graphics.images.card_spell, x, y)
  end
  -- Draw the card name
  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont(graphics.fonts.small)
  love.graphics.printf(graphic.card.name, x, y + 112, deckmanager.card_w, "center")
  -- Draw the card value
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(graphics.fonts.large_numbers)
  love.graphics.printf(graphic.card.value, x, y + 81, deckmanager.card_w, "center")
end

-- Called when the mouse is pressed
handmanager.mousepressed = function(x, y, button)
  if game.state == "place" then
    if button == 1 then
      -- If card is hovered over, and mouse is pressed, mark that card as selected
      if handmanager.hover then
        handmanager.selected = handmanager.hover
        -- Reset hold time
        hold_time = 0
        return true -- mar that the click has been used
      else -- Otherwise, mark no card as selected
        handmanager.selected = false
      end
    end
    return false
  end
end

-- Called when a key is pressed
handmanager.keypressed = function(key)
  if game.state == "place" then
    -- Convert numerical key to a selected card
    local i = tonumber(key)
    if i and i > 0 and i <= handmanager.hand_size then
      handmanager.selected = i
    end
  end
end

-- Fills the players hand up to the number of cards that should be in one
handmanager.fill_hand = function(deck)
  for i = #handmanager.hand + 1, handmanager.hand_size do
    -- Make sure cards are left in the deck
    if #deck > 0 then
      -- Take cards from the deck to create the player's initial hand
      local card = math.random(1, #deck)
      handmanager.hand[i] = deck[card]
      table.remove(deck, card)

      table.insert(handmanager.hand_graphics, {card = handmanager.hand[i], x = deckmanager.x, y = deckmanager.y})
    end
  end
end

handmanager.card_placed = function()
  table.remove(handmanager.hand, handmanager.selected)
  table.remove(handmanager.hand_graphics, handmanager.selected)
  handmanager.grabbed = false
  handmanager.selected = false
  handmanager.fill_hand(deckmanager.deck)
end

return handmanager

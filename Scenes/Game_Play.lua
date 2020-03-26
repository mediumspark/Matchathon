local Game_Play = {}

local TIME_REMAINING_CONS = 15
local TIME_BONUS_CONS = 1.2
local GAME_OVER_CONS = false
local SCORE_CONS = 0
local NUMBER_TO_ADD_CONS = 4


function Game_Play:load(arg)

    TimeRemaining = TIME_REMAINING_CONS
    TimeBonus = TIME_BONUS_CONS

    Number_to_add = NUMBER_TO_ADD_CONS
    game_over = GAME_OVER_CONS

    Score = SCORE_CONS

    circle = love.graphics.newImage("Assets/Circle.png")
    diamond = love.graphics.newImage("Assets/Diamond.png")
    heart = love.graphics.newImage("Assets/Heart.png")
    square = love.graphics.newImage("Assets/Square.png")
    star = love.graphics.newImage("Assets/Star.png")
    trapazoid = love.graphics.newImage("Assets/Trap.png")
    triangle = love.graphics.newImage("Assets/Triangle.png")

    Shapes = {circle, diamond, heart, square,
    star, trapazoid, triangle}

    Random_correct_position_x = love.math.random(20, 500)
    Random_correct_position_y = love.math.random(20, 500)

    Random_correct_shape = love.math.random(1,6)

    Player = {
      Speed = 200,
      Score = 0,
      shape_given = Shapes[Random_correct_shape],
      x = 250, y = 250
    }

    ShapeObject = {}
    ShapeObject.__index = ShapeObject

    function ShapeObject:new(image, xVert, yVert)
      local this = {
        shape_image = image,
        x = xVert,
        y = yVert,
        h = image:getHeight(),
        l = image:getWidth()
      }
      setmetatable(this, ShapeObject)
      return this
    end

  TotalListOfShapes = {}

  answer = ShapeObject:new(Shapes[Random_correct_shape], Random_correct_position_x,
   Random_correct_position_y)
  table.insert(TotalListOfShapes, answer)

end

function Game_Play:update(dt)
  -- body...
  Score = Player.Score

  if love.keyboard.isDown('w') and Player.y >= 10 then
    Player.y = Player.y - Player.Speed * dt
  elseif love.keyboard.isDown('s') and Player.y <= love.graphics.getHeight() -
  Player.shape_given:getHeight() then
    Player.y = Player.y + Player.Speed * dt
  end

  if love.keyboard.isDown('a') and Player.x >= 10 then
    Player.x = Player.x - Player.Speed * dt
  elseif love.keyboard.isDown('d') and Player.x + 5 <= love.graphics.getWidth() -
  Player.shape_given:getWidth() then
    Player.x = Player.x + Player.Speed * dt
  end

  if love.mouse.isDown(1,2,3) and Player.y >= 10 and Player.y <=
  love.graphics.getHeight() - Player.shape_given:getHeight()  and Player.x >= 10
  and Player.x + 5 <= love.graphics.getWidth() - Player.shape_given:getWidth() then
    Player.x = love.mouse.getX()
    Player.y = love.mouse.getY()
  end

  TimeRemaining = TimeRemaining - dt
  Time = string.format("%4.2f",TimeRemaining)

  if TimeRemaining <= 0 then
    TimeRemaining = 0
    Time = ""..0.00
    game_over = true
  end

  for index in pairs(TotalListOfShapes) do
    if collision(Player, TotalListOfShapes[index]) and not game_over then
      if Player.shape_given == TotalListOfShapes[index].shape_image then
        if TimeRemaining < 30 then
          TimeRemaining = TimeRemaining + TimeBonus
        elseif TimeRemaining >= 30 then
          TimeBonus = 0
        end
        Player.Score = Player.Score + 1
        Number_to_add = Number_to_add + 3
        refresh()
      end
    end
  end
end

function Random_Corrector(table, correct_number)
  for key in pairs(table) do
    if table[key].shape_image == correct_number then
      table[key] = love.math.random(1,6)
      return Random_Corrector(table, correct_number)
    end
  end
end

function refresh()

  for key in pairs(TotalListOfShapes) do
    table.remove(TotalListOfShapes, 1)
  end

  Random_correct_shape = love.math.random(1,6)
  Random_correct_position_x = love.math.random(40, love.graphics.getWidth()-
  Shapes[1]:getWidth()- 10)
  Random_correct_position_y = love.math.random(20, love.graphics.getHeight()-
  Shapes[1]:getHeight())

  Player.shape_given = Shapes[Random_correct_shape]
  answer = ShapeObject:new(Shapes[Random_correct_shape], Random_correct_position_x,
  Random_correct_position_y)
  table.insert(TotalListOfShapes, answer)

  for index = 1, Number_to_add do

    Random_incorrect_position_y = love.math.random(40, love.graphics.getHeight()-
    Shapes[1]:getHeight())
    Random_incorrect_position_x = love.math.random(20, love.graphics.getWidth()-
    Shapes[1]:getWidth() - 10)

    Random_incorrect_shape = love.math.random(1,6)

    wrong_shape = ShapeObject:new(Shapes[Random_incorrect_shape], Random_incorrect_position_x,
    Random_incorrect_position_y)
    table.insert(TotalListOfShapes, wrong_shape)

    Random_Corrector(TotalListOfShapes, Random_correct_shape)
  end
end

function collision(Object, Col)
  if Object.x <= Col.x + Col.l and Object.x >= Col.x - Col.l
    and Object.y <= Col.y + Col.h and Object.y >= Col.y - Col.h then
      return true
  end
end

function Game_Play:Game_is_Over()
  return game_over
end

function Game_Play:Start_new_game()
  TimeRemaining = TIME_REMAINING_CONS
  TimeBonus = TIME_BONUS_CONS

  Number_to_add = NUMBER_TO_ADD_CONS
  game_over = GAME_OVER_CONS

  Score = SCORE_CONS
end

function Game_Play:Set_Score()
  return Player.Score
end


function Game_Play:draw()
  -- body...
  love.graphics.draw(Player.shape_given, Player.x, Player.y)
  love.graphics.printf(Time, 0, 0, 200, center)
  love.graphics.print(Player.Score, 0, 20)

  for key in pairs(TotalListOfShapes) do
      love.graphics.draw(TotalListOfShapes[key].shape_image, TotalListOfShapes[key].x,
      TotalListOfShapes[key].y)
    end
end

return Game_Play

local GameplayScene = require ("Scenes.Game_Play")
local Game_Start_Scene = require ("Scenes.Game_start")
--local Game_over = require ("Scenes.Game_over")

 State_Machine = {Game_Start_Scene, GameplayScene, Game_over}
 Current_State = State_Machine[1]
 Score = 0

function love.load(arg)
  Current_State.load(self, arg)
end

function love.update(dt)

  if love.keyboard.isDown('escape') then
    love.event.push('quit')
  end

  if Current_State == State_Machine[1] then
    if love.keyboard.isDown('space') or love.mouse.isDown(1,2,3) then
      Current_State = State_Machine[2]
      Current_State.load(self)
    end

  elseif Current_State == State_Machine[2] then
    Score = Current_State.Set_Score()
    if Current_State.Game_is_Over() then
      Current_State = State_Machine[3]
      Current_State.load(self)
      Current_State.Give_Final_Score(self, Score)
    end

  elseif Current_State == State_Machine[3] then
    if love.keyboard.isDown('space') or love.mouse.isDown(1,2,3) then
      State_Machine[2].Start_new_game()
      Current_State = State_Machine[2]
      Current_State.load(self)
    end
  end

    Current_State.update(self, dt)
end


function love.draw()
  Current_State.draw(self)
end

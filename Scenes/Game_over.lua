local Game_over = {}
local Gameplay = require "Game_play"


function Game_over:load(arg)
  -- body...
  Final_Score = 0
end

function Game_over:update(dt)
  -- body...
end

function Game_over:draw()
  -- body...
  love.graphics.print(Final_Score, 250, 250)
  love.graphics.print("Press Space or tap the screen to play again!", 250, 270)
end

function Game_over:Give_Final_Score(newScore)
  Final_Score = newScore
end


return Game_over

package.path = package.path .. ";" .. paths.concat(paths.thisfile(), "../../maze_generator/lib") .. "/?.lua"
require "maze"

Environment = {}
Environment.__index = Environment

setmetatable(Environment, {
  __call = function (cls, ...)
    return cls.new(...)
  end
})


function Environment.new()
  local self = setmetatable({}, Environment)
  self.size = { 9, 9 }
  self.maze = Maze(self.size)
  self.current_coordinate = { 0, 0 }
  self.move_count = 0
  return self
end

--[[
Align current coordinate to maze cell.
The agent starts its move from the center of the maze, but it recognize the
location as (0, 0). Thus the shift of coordinate must be compensated.
--]]
function Environment:cell(coordinate)
  local shift_x = math.floor((self.size[1] + 1) / 2)
  local shift_y = math.floor((self.size[2] + 1) / 2)

  return { coordinate[1] + shift_x, coordinate[2] + shift_y }
end

function Environment:wall(coordinate)
  return self.maze:wall(self:cell(coordinate))
end

function Environment:move(direction)
  local neighbor = {
    { self.current_coordinate[1] - 1, self.current_coordinate[2]     },
    { self.current_coordinate[1],     self.current_coordinate[2] + 1 },
    { self.current_coordinate[1] + 1, self.current_coordinate[2]     },
    { self.current_coordinate[1],     self.current_coordinate[2] - 1 },
  }
  if self:wall(self.current_coordinate)[direction] == 0 then
    self.current_coordinate = neighbor[direction]
  end
  self.move_count = self.move_count + 1
end

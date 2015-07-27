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
  self.history = { { 0, 0 } }
  self.novelty = 0
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

function Environment:move(direction)
  local neighbor = {
    { self.current_coordinate[1] - 1, self.current_coordinate[2]     },
    { self.current_coordinate[1],     self.current_coordinate[2] + 1 },
    { self.current_coordinate[1] + 1, self.current_coordinate[2]     },
    { self.current_coordinate[1],     self.current_coordinate[2] - 1 },
  }
  if self:wall()[direction] == 0 then
    self.current_coordinate = neighbor[direction]
  end
  self.move_count = self.move_count + 1
  self:check_novelty()
end

function Environment:check_novelty()
  local flag = false
  for _, v in ipairs(self.history) do
    -- Lua does not have an operator to compare table values
    if v[1] == self.current_coordinate[1] and v[2] == self.current_coordinate[2] then
      flag = true
      break
    end
  end
  if flag then
    self.novelty = 0
  else
    self.novelty = 10
    self.history[#self.history + 1] = self.current_coordinate
  end
end

function Environment:wall()
  return self.maze:wall(self:cell(self.current_coordinate))
end

function Environment:reset()
  self.current_coordinate = { 0, 0 }
  self.move_count = 0
  self.history = { { 0, 0 } }
  self.novelty = 0
end

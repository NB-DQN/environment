LEARNING ENVIRONMENT FOR NB-DQN
================================

### Repository setup
```sh
ln -s /path/to/maze_generator maze_generator
```

### Requirements
* Lua >= 5.2
* Torch7

### API
```Lua
-- Create new learning environment
e = Environment() -- the size of maze field is 9x9

-- Reset current environment (clear movment history)
e:reset()

-- Move agent in the maze
e:move(direction)

-- get agent's visual information about wall
e:wall() -- => [0; 0; 1; 1]

-- get the coordinate where the agent currently exists
e.current_coordinate -- => { 0, 1 }

-- get the novelty that is given for last movement
e.novelty -- => 0 or 10
```

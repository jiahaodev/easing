local easing = require("easing")

local RADIUS = W / 50
local DURATION = 2  --动画的持续时间，写死为1

--[[
  For all easing functions:
  t = time
  b = begin
  c = change == ending - beginning
  d = duration
]]


local function movingDot(height, funcName)
  local self = {}

  local fun = easing[funcName]

  local function downFun(v)
    return fun(v, 0, height, DURATION)
  end

  local function upFun(v)
    return fun(v, height, -height, DURATION)
  end

  local offset = 0 -- property to ease.
  local timeElapsed = 0  --时间消逝，过去
  local currentFun = downFun

  function self.update(dt)
    timeElapsed = timeElapsed + dt

    if timeElapsed > DURATION then
      timeElapsed = 0
      if currentFun == downFun then 
        currentFun = upFun 
      else 
        currentFun = downFun 
      end
    end

    offset = currentFun(timeElapsed)
  end

  function self.render(x, y)
    -- x : y 一直是720,140。 即第一条蓝色线的中心位置
    love.graphics.setColor(0, 0, 255, 255)
    --画两条线，位置不变的
    love.graphics.line(x - 20, y, x + 20, y)         
    love.graphics.line(x - 20, y + height, x + 20, y + height)

    --驱动球不断变化位置：核心数据 offset，由 update函数计算
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.circle("fill", x, y + offset, RADIUS, RADIUS)    -- 核心就是这句话
    self.showDebugLog(x, y)
  end

    --显示打印信息
  function self.showDebugLog(x, y)
      -- x : y 一直是720,140
      -- love.graphics.setColor(0, 255, 0, 255)
      -- love.graphics.print("X::Y="..tostring(x).."::"..tostring(y), 0, 0)
      -- love.graphics.print("x,y is __here__", x, y)
  end

  return self
end

return movingDot

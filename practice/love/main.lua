--[[
wiki:链接
https://love2d.org/wiki/love

love2d用法：
-- to do one-time setup of your game 
-- 一次性初始化游戏状态
function love.load()
    x, y, w, h = 20, 20, 60, 20
end
 
--  love.update which is used to manage your game's state frame-to-frame,
--  处理帧到帧之间的游戏状态（即更新数据）
function love.update(dt)
    w = w + 1
    h = h + 1
end
 
-- which is used to render the game state onto the screen.
-- 将update中更新的状态 ，渲染到屏幕上
function love.draw()
    love.graphics.setColor(0, 0.4, 0.4)
    love.graphics.rectangle("fill", x, y, w, h)
end
--]]


W = 800
H = 600

-- graphicate easing functions using love2d.
local easing = require("easing")
local renderFun = require("renderFun")
local movingDot = require("movingDot")

FONT_SIZE = 14
SEGMENTS = 500
POINT_SIZE = 2
LINE_SIZE = 2
GRAPH_SIZE = 0.6 -- percent of screen.
--------------------------------------------------
CHART_W = W * GRAPH_SIZE
CHART_H = H * GRAPH_SIZE * (W / H)
CHART_X = ( W - CHART_W ) / 2
CHART_Y = ( H - CHART_H ) / 2

lastDT = 0

function love.load()
  love.graphics.setFont(love.graphics.newFont(FONT_SIZE))
  love.graphics.setLineWidth(LINE_SIZE)
  love.graphics.setLineStyle("smooth")
  love.graphics.setPointSize(POINT_SIZE)

  -- put all easing function names inside an array for easy navigation by array index.
  functions = {}
  for funName, _ in pairs(easing) do
    functions[#functions + 1] = funName
  end
  table.sort(functions)
  selFun = 1

  dot = movingDot(CHART_H * 2 / 3, functions[selFun])
end

function love.draw()
  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.print("Press up and down to change the easing function.", 50, CHART_Y - 50)
  love.graphics.print(selFun .. "/" .. #functions .. " - " .. functions[selFun], CHART_X + CHART_W - 50, CHART_Y - 50)

  dot.render(W - (W - CHART_X - CHART_W) / 2, CHART_Y + CHART_H * 2 / 3 / 4, functions[selFun])  -- 画球
  renderFun(CHART_X, CHART_Y, CHART_W, CHART_H, functions[selFun])                            -- 画表格

  love.showDebugLog() --打印debug信息
end

--显示打印信息
function love.showDebugLog( )
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.print("LastDt:"..lastDT, -50, -20)
end

function love.update(dt)
  lastDT = dt
  dot.update(dt)
end

function love.keypressed(key, unicode)
  if key == 'down' then
    if selFun > 1 then
      selFun = selFun - 1
      dot = movingDot(CHART_H * 2 / 3, functions[selFun])
    end
  elseif key == 'up' then
    if selFun < #functions then
      selFun = selFun + 1
      dot = movingDot(CHART_H * 2 / 3, functions[selFun])
    end
  end
end

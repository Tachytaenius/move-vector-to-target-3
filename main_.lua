local vec2 = require("lib.mathsies").vec2

local normaliseOrZero = require("normalise-or-zero")
local limitVectorLength = require("limit-vector-length")
local moveVelocityVector = require("move-velocity-vector")

local maxTargetLength = 250
local targetMoveRate = 100

local target = vec2()
local current = vec2()
local currentMoveRate = 50

function love.update(dt)
	if love.keyboard.isDown("c") then
		current = vec2()
	end
	if love.keyboard.isDown("t") then
		target = vec2()
	end

	local targetMove = vec2()
	if love.keyboard.isDown("w") then
		targetMove.y = targetMove.y - 1
	end
	if love.keyboard.isDown("s") then
		targetMove.y = targetMove.y + 1
	end
	if love.keyboard.isDown("a") then
		targetMove.x = targetMove.x - 1
	end
	if love.keyboard.isDown("d") then
		targetMove.x = targetMove.x + 1
	end
	targetMove = normaliseOrZero(targetMove) * targetMoveRate
	target = limitVectorLength(target + targetMove * dt, maxTargetLength)

	current = moveVelocityVector(current, target, currentMoveRate, dt, 0.5)
end

function love.draw()
	love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)

	love.graphics.circle("line", 0, 0, maxTargetLength)
	love.graphics.circle("line", 0, 0, #target)

	love.graphics.line(0, -maxTargetLength, 0, maxTargetLength)
	love.graphics.line(-maxTargetLength, 0, maxTargetLength, 0)

	love.graphics.setPointSize(8)
	love.graphics.points(target.x, target.y)

	love.graphics.setPointSize(6)
	love.graphics.points(current.x, current.y)

	love.graphics.origin()
end

function love.mousepressed(x, y, button)
	local newPos = vec2(x - love.graphics.getWidth() / 2, y - love.graphics.getHeight() / 2)
	if button == 1 then
		current = newPos
	elseif button == 2 then
		target = newPos
	end
end

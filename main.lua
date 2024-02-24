local vec2 = require("lib.mathsies").vec2

local normaliseOrZero = require("normalise-or-zero")
local moveVelocityVector = require("move-velocity-vector")

local maxSpeed = 200
local acceleration = 600
local dots = {}
local pos, vel

function love.load()
	for i = 1, 2500 do
		dots[i] = {
			x = love.math.random() * 1000,
			y = love.math.random() * 1000
		}
	end
	pos = vec2()
	vel = vec2()
end

function love.update(dt)
	local target = vec2()
	if love.keyboard.isDown("w") then
		target.y = target.y - 1
	end
	if love.keyboard.isDown("s") then
		target.y = target.y + 1
	end
	if love.keyboard.isDown("a") then
		target.x = target.x - 1
	end
	if love.keyboard.isDown("d") then
		target.x = target.x + 1
	end
	target = normaliseOrZero(target) * maxSpeed

	vel = moveVelocityVector(vel, target, acceleration, dt, 0.4)
	pos = pos + vel * dt
end

function love.draw()
	love.graphics.translate(-pos.x, -pos.y)
	love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)

	for _, dot in ipairs(dots) do
		love.graphics.points(dot.x, dot.y)
	end

	love.graphics.circle("line", pos.x, pos.y, 10)
end

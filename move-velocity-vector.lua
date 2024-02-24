local vec2 = require("lib.mathsies").vec2

local moveVectorToOther = require("move-vector-to-other")
local limitVectorLength = require("limit-vector-length")
-- local normaliseOrZero = require("normalise-or-zero")
local getShortestAngleDifference = require("get-shortest-angle-difference")

-- return function(current, target, maxSpeed, acceleration, dt, accelTypeAmount)
-- 	accelTypeAmount = accelTypeAmount or 0
-- 	local toTargetAccel = (1 - accelTypeAmount) * acceleration
-- 	local inTargetDirectionAccel = accelTypeAmount * acceleration

-- 	-- Accelerate in direction of target
-- 	local magnitudeLimit = math.max(maxSpeed, #current)
-- 	local newCurrent = limitVectorLength(current + normaliseOrZero(target) * inTargetDirectionAccel * dt, magnitudeLimit)

-- 	-- Linearly move towards target
-- 	return moveVectorToOther(newCurrent, target, toTargetAccel, dt)
-- end

-- The above function does not maintain a constant rate of acceleration a lot of the time (though neither maintains that when pushing against limitVectorLength)
-- It also uses a maxSpeed variable when it could use #target

return function(current, target, acceleration, dt, lerpFactor)
	-- If we could jump this frame, do so
	if vec2.distance(current, target) <= acceleration * dt then
		return vec2.clone(target)
	end
	-- Avoid passing the zero vector to toAngle
	if target == vec2() then
		return moveVectorToOther(current, target, acceleration, dt)
	end

	lerpFactor = lerpFactor or 0
	if #current > #target then
		lerpFactor = 0
	end

	-- Calculate direction which is between direction from current to target and direction of target itself (lerpFactor being 0 is former, lerpFactor being 1 is latter).
	-- The "if target is zero vector" guard clause (as well as the jump range check) prevents calling toAngle on a zero vector, since that shouldn't return a number.
	-- But if it does return a number, and target is the zero vector and current is somewhere else, the if statement above would have set lerpFactor to 0, therefore
	-- making the direction of movement be the direction from current to target.
	local inTargetDirectionAngle = vec2.toAngle(target)
	local toTargetAngle = vec2.toAngle(target - current)
	local angleDifference = getShortestAngleDifference(inTargetDirectionAngle, toTargetAngle)
	local lerpedAngle = toTargetAngle - angleDifference * lerpFactor
	local moveDirection = vec2.fromAngle(lerpedAngle)

	-- Move current in the movement direction but don't go above target speed, or if higher, current speed
	local magnitudeLimit = math.max(#target, #current)
	local movedCurrent = current + moveDirection * acceleration * dt
	local limitedMovedCurrent = limitVectorLength(movedCurrent, magnitudeLimit)

	return limitedMovedCurrent
end

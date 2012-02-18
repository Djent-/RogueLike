Sprite = {}

function Sprite:new(x,y)
	local sprite = {}

	sprite.x = x
	sprite.y = y
	sprite.velx = 0
	sprite.vely = 0
	sprite.maxvel = 120
	sprite.accel = 16
	sprite.tileSize = 16
	sprite.currentSpriteX = 0
	sprite.currentSpriteY = 0
	sprite.solid = false
	sprite.moving = false
	sprite.newPos = 0
	sprite.currentTileX = 0
	sprite.currentTileY = 0
	sprite.health = 100
	sprite.level = 1

	sprite.currentWeapon = nil
	sprite.dmg = 3 * sprite.level

	sprite.enemy = false

	sprite.collisionPoints = {}
	sprite.direction = 'l'

	function sprite:superUpdate(battle,lvl,dt)
		sprite.collisionPoints = lvl:getCollision(sprite.currentTileX,sprite.currentTileY)

		sprite.x = sprite.x + sprite.velx * dt
		sprite.y = sprite.y + sprite.vely * dt
	end

	function sprite:moveOnGrid(direction)
		if direction == 'l' and sprite.moving then
			if sprite.x >= sprite.newPos then
				if sprite.velx >= -sprite.maxvel then
					sprite.velx = sprite.velx - sprite.accel
				end
			elseif sprite.x <= sprite.newPos then
				sprite.x = sprite.newPos
				sprite.velx = 0
				sprite.moving = false
			end
		elseif direction == 'r' and sprite.moving then
			if sprite.x <= sprite.newPos then
				if sprite.velx <= sprite.maxvel then
					sprite.velx = sprite.velx + sprite.accel
				end
			elseif sprite.x >= sprite.newPos then
				sprite.x = sprite.newPos
				sprite.velx = 0
				sprite.moving = false
			end
		elseif direction == 'u' and sprite.moving then
			if sprite.y >= sprite.newPos then
				if sprite.vely >= -sprite.maxvel then
					sprite.vely = sprite.vely - sprite.accel
				end
			elseif sprite.y <= sprite.newPos then
				sprite.y = sprite.newPos
				sprite.vely = 0
				sprite.moving = false
			end
		elseif direction == 'd' and sprite.moving then
			if sprite.y <= sprite.newPos then
				if sprite.vely <= sprite.maxvel then
					sprite.vely = sprite.vely + sprite.accel
				end
			elseif sprite.y >= sprite.newPos then
				sprite.y = sprite.newPos
				sprite.vely = 0
				sprite.moving = false
			end
		end

	end

	function sprite:blockInWay()
		for i = 1, #sprite.collisionPoints do
			if sprite.direction == sprite.collisionPoints[i] then
				return true
			end
		end
		return false
	end

	return sprite
end

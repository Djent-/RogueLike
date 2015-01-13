require("entities/sprite")
require("screen/dialogue")

Enemy = {}

function Enemy:new(x,y,enemyType)
	local e = Sprite:new(x,y)

	e.enemy = true
	e.solid = true
	e.level = 1
	e.currentTileX = x
	e.currentTileY = y
	e.name = enemyType[1]

	e.battleY = enemyType[5]
	e.currentSpriteX = 0
	e.currentSpriteY = enemyType[4]
	e.health = 170
	e.timerLength = 2
	e.aiTimer = 0
	e.randPosX = nil
	e.randPosY = nil
	e.dontIdle = false

	e.weapons = enemyType[3]
	e.currentWeapon = e.weapons[1]
	e.attacks = e.currentWeapon.attacks

	e.defense = 1

	e.x = e.tileSize * e.currentTileX
	e.y = e.tileSize * e.currentTileY

	function e:update(battle,npcs,lvl,dt)
		e:superUpdate(battle,lvl,dt)
 		e:ai(lvl,dt)
 	end

	function e:healthToString(gui)
		local strHealth = ""
		if gui == 0 then
			for i = 1, e.health / 19 do
				strHealth = strHealth .. "#"
			end
		else
			for i = 1, e.health / 16 do
				strHealth = strHealth .. "#"
			end
		end
		return strHealth
	end

	function e:ai(lvl,dt)
		local distX = lvl.player.currentTileX - e.currentTileX
		local distY = lvl.player.currentTileY - e.currentTileY

		if lvl.player.moving then
			e.dontIdle = true
		else
			e.dontIdle = false
		end
		e:idleai(lvl,dt)
	end

	function e:idleai(lvl,dt)
		if e.aiTimer >= 0 then
			e.aiTimer = e.aiTimer + dt
			if e.aiTimer >= e.timerLength then
				if not e.dontIdle then
					e:changeSprite()
					local willMove = math.random(0,2)
					if willMove == 0 or willMove == 2 then
						e:moveRandom(lvl)
					end
				end
				e.timerLength = math.random(1.5,2)
				e.aiTimer = 0
			end
		end
		e:moveOnGrid(e.direction)
	end

	function e:moveRandom(lvl)
		local direction = math.random(0,3)
		if direction == 0 and e.y >= 0 then
			e.direction = 'u'
		elseif direction == 1  and e.x <= GAME_WIDTH - 16 then
			e.direction = 'r'
		elseif direction == 2 and e.y <= GAME_HEIGHT - 16 then
			e.direction = 'd'
		elseif direction == 3 and e.x > 0  then
			e.direction = 'l'
		end

		if not e:blockInWay() then
			e.moving = true
			if e.direction == 'u' then
				e.currentTileY = e.currentTileY - 1
				e.newPos = (e.tileSize * e.currentTileY)
			elseif e.direction == 'd' then
				e.currentTileY = e.currentTileY + 1
				e.newPos = (e.tileSize * e.currentTileY)
			elseif e.direction == 'r' then
				e.currentTileX = e.currentTileX + 1
				e.newPos = (e.tileSize * e.currentTileX)
			elseif e.direction == 'l' then
				e.currentTileX = e.currentTileX - 1
				e.newPos = (e.tileSize * e.currentTileX)
			end
		end
	end

	function e:changeSprite()
		local x = math.random(0,1)
		e.currentSpriteX = x * e.tileSize
	end

	function e:draw(sprites)
		love.graphics.draw(sprites.img,sprites:getSpriteQuad(e.currentSpriteX,e.currentSpriteY * e.tileSize),e.x,e.y)
	end

	return e
end

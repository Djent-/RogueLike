require("entities/sprite")
require("screen/dialogue")

Player = {}

function Player:new(x,y)
	local player = Sprite:new(x,y)

	player.solid = true
	player.colliding = false

	player.currentTileX = 2
	player.currentTileY = 6
	player.x = player.tileSize * player.currentTileX
	player.y = player.tileSize * player.currentTileY
	player.canChangeLevel = true
	player.maxHealth = 170
	player.health = player.maxHealth
	player.xp = 0
	player.level = 1
	player.name = "sir adam"
	player.inDialogue = false
	player.score = 0
	player.dead = false

	player.abilities = {abilities.block}
	player.items = {consumables.healthPotion, consumables.mushroom, consumables.chocCandy}

	player.weapons = {weapons.shortSword,weapons.karate}
	player.currentWeapon = player.weapons[1]
	player.attacks = player.currentWeapon.attacks

	player.defense = 5

	function player:update(battle,npcs,lvl, dt)
		player:superUpdate(battle,lvl,dt)
		player:moveControls(lvl.tiles,dt)
		player:changeLvls(lvl)
		player:hitsprite(lvl.sprites[lvl.currentLevel],npcs,battle)
	end

	function player:draw(sprites)
		love.graphics.drawq(sprites.img,sprites:getSpriteQuad(player.currentSpriteX,player.currentSpriteY),player.x,player.y)
	end

	function player:healthToString(size)
		local strHealth = ""
		if size == 0 then
			for i = 1, player.health / 16 do
				strHealth = strHealth .. "#"	
			end
		else
			for i = 1, player.health / 19 do
				strHealth = strHealth .. "#"
			end
		end
		return strHealth
	end

	function player:moveControls(tiles,dt)
		if love.keyboard.isDown("left") and not player.moving then
			player:changeSprite(1,0)
			player.direction = 'l';
			if not player:blockInWay() then
				player.moving = true
				player.currentTileX = player.currentTileX - 1
				player.newPos = (player.tileSize * player.currentTileX)
			end
		elseif love.keyboard.isDown("right") and not player.moving then
			player:changeSprite(0,0)
			player.direction = 'r';
			if not player:blockInWay() then
				player.moving = true
				player.currentTileX = player.currentTileX + 1
				player.newPos = (player.tileSize * player.currentTileX)
			end
		elseif love.keyboard.isDown("up") and not player.moving then
			player.direction = 'u';
			if not player:blockInWay() then
				player.moving = true
				player.currentTileY = player.currentTileY - 1
				player.newPos = (player.tileSize * player.currentTileY)
			end
		elseif love.keyboard.isDown("down") and not player.moving then
			player.direction = 'd';
			if not player:blockInWay() then
				player.moving = true
				player.currentTileY = player.currentTileY + 1
				player.newPos = (player.tileSize * player.currentTileY)
			end
		end
		player:moveOnGrid(player.direction)
	end

	function player:hitsprite(sprites,npcs,battle)
		for i = 1, #sprites do
			if player.x == sprites[i].x - player.tileSize and player.y == sprites[i].y then
				if love.keyboard.isDown("right") then
					if sprites[i].enemy then
						battle:engage(player,sprites,i)
					end
				end
			end
			if player.x == sprites[i].x + sprites[i].tileSize and player.y == sprites[i].y then
				if love.keyboard.isDown("left") then
					if sprites[i].enemy then
						battle:engage(player,sprites,i)
					end
				end
			end
			if player.y == sprites[i].y + sprites[i].tileSize and player.x == sprites[i].x then
				if love.keyboard.isDown("up") then
					if sprites[i].enemy then
						battle:engage(player,sprites,i)
					end
				end
			end
			if player.y == sprites[i].y - sprites[i].tileSize and player.x == sprites[i].x then
				if love.keyboard.isDown("down") then
					if sprites[i].enemy then
						battle:engage(player,sprites,i)
					end
				end
			end
		end
		--npcs
		for i = 1, #npcs do
			if player.x == npcs[i].x - player.tileSize and player.y == npcs[i].y then
				if love.keyboard.isDown("right") then
					npcs[i]:showDialogue(player)
				end
			end
			if player.x == npcs[i].x + npcs[i].tileSize and player.y == npcs[i].y then
				if love.keyboard.isDown("left") then
					npcs[i]:showDialogue(player)
				end
			end
			if player.y == npcs[i].y + npcs[i].tileSize and player.x == npcs[i].x then
				if love.keyboard.isDown("up") then
					npcs[i]:showDialogue(player)
				end
			end
			if player.y == npcs[i].y - npcs[i].tileSize and player.x == npcs[i].x then
				if love.keyboard.isDown("down") then
					npcs[i]:showDialogue(player)
				end
			end
		end
	end

	function player:changeSprite(x,y)
		player.currentSpriteX = x * e.tileSize
		player.currentSpriteY = y * e.tileSize
	end

	function player:changeLvls(lvl)
		if player.currentTileX == 10 then
			player.newPos = 0
			player.currentTileX = 0
			player.x = -16
			lvl.currentLevel = lvl.currentLevel + 1
		elseif player.currentTileX == -1 then
			player.currentTileX = 9
			player.newPos = player.currentTileX * 16
		
			player.x = GAME_WIDTH
			lvl.currentLevel = lvl.currentLevel - 1
		end
	end

	return player
end

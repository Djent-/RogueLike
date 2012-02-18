require("entities/sprite")
require("screen/dialogue")

NPC = {}

function NPC:new(x,y,npcData)
	local npc = Sprite:new(x,y)

	npc.name = npcData[1]
	npc.currentTileX = x
	npc.currentTileY = y
	npc.currentSpriteX = 0
	npc.currentSpriteY = npcData[4]
	npc.enemy = false

	npc.x = npc.tileSize * npc.currentTileX
	npc.y = npc.tileSize * npc.currentTileY
	npc.currentMessage = 1

	npc.dialogue = Dialogue:new(0,GAME_HEIGHT,npcData[1],npcData[6])
	npc.inDialogue = false
	npc.player = nil

	function npc:update(battle,npcs,lvl,dt)
		npc:superUpdate(battle,lvl,dt)

		if npc.inDialogue then
			npc.dialogue:update(npc.currentMessage,dt)
		end

		if npc.player ~= nil then
			if npc.player.currentTileX == npc.currentTileX - 1 and npc.player.currentTileY == npc.currentTileY then --left
				if love.keyboard.isDown("right") then
					npc.inDialogue = true
					npc.dialogue.active = true
				end
			elseif npc.player.currentTileX == npc.currentTileX + 1 and npc.player.currentTileY == npc.currentTileY then--right
				if love.keyboard.isDown("left") then
					npc.inDialogue = true
					npc.dialogue.active = true
				end
			elseif npc.player.currentTileY == npc.currentTileY - 1 and npc.player.currentTileX == npc.currentTileX then--up
				if love.keyboard.isDown("down") then
					npc.inDialogue = true
					npc.dialogue.active = true
				end
			elseif npc.player.currentTileY == npc.currentTileY + 1 and npc.player.currentTileX == npc.currentTileX then--down
				if love.keyboard.isDown("up") then
					npc.inDialogue = true
					npc.dialogue.active = true
				end
			else
				npc.inDialogue = false
				npc.dialogue.active = false
			end
		end
		end

	function npc:showDialogue(player)
		npc.player = player
	end

	function npc:draw(sprites)
		love.graphics.drawq(sprites.img,sprites:getSpriteQuad(npc.currentSpriteX,npc.currentSpriteY * npc.tileSize),npc.x,npc.y)
		if npc.dialogue.active then
			npc.dialogue:render()
		end
	end

	return npc
end
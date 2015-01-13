require("entities/player")
require("entities/sprite")
require("entities/npc")
require("entities/enemy")
require("entities/itemmanager")

Level = {}

function Level:new()
 	local l = {}
 	l.tileSize = 16
 	l.levels = {}
 	l.tiles = {}
 	l.currentLevel = 1
 	l.sprites = {}
 	l.npcs = {}
 	l.player = Player:new(0,0)

 	function l:createLevel(levels,sprites,npcTypes)
 		for i = 1, #levels do
 			local lTiles = {}
	 		for y = 1, #levels[i] do
	 			for x = 1, #levels[i][y] do
	 				local tile = Sprite:new((x - 1) * l.tileSize,(y - 1) * l.tileSize)
	 				tile.currentTileX = x - 1
	 				tile.currentTileY = y - 1
	 				tile.currentSpriteX = levels[i][y][x].x
	 				tile.currentSpriteY = levels[i][y][x].y
	 				tile.solid = levels[i][y][x].solid
	 				table.insert(lTiles, tile)
	 			end
	 		end
	 		table.insert(l.levels,lTiles)
	 	end
	 	for i = 1, #sprites do
	 		local ss = {}
	 		local sn = {}
	 		for y = 1, #sprites[i] do
	 			for x = 1, #sprites[i][y] do
	 				if sprites[i][y][x] == 0 then

		 			elseif sprites[i][y][x] > 0 then
		 				if npcTypes[sprites[i][y][x]][2] == true then
		 					local enemy = Enemy:new(x,y,npcTypes[sprites[i][y][x]])
		 					table.insert(ss,enemy)
		 				elseif npcTypes[sprites[i][y][x]][2] == false then
		 					local npc = NPC:new(x,y,npcTypes[sprites[i][y][x]])
		 					table.insert(sn,npc)
		 				end
		 			end
	 			end
	 		end
	 		table.insert(l.npcs,sn)
	 		table.insert(l.sprites,ss)
	 	end
	 	for i = 1,#l.sprites do
	 		table.insert(l.sprites[i],l.player)
	 	end
 	end

 	function l:update(battle,lvl,dt)
 		for i = 1, #l.sprites[l.currentLevel] do
 			l.sprites[l.currentLevel][i]:update(battle,l.npcs[l.currentLevel],lvl,dt)
 		end
 		for i = 1, #l.npcs[l.currentLevel] do
 			l.npcs[l.currentLevel][i]:update(battle,l.npcs[l.currentLevel],lvl,dt)
 		end
 	end

 	function l:getCollision(currentX,currentY)
 		local collides = {"x","x","x","x"}
 		local lvl = l.levels[l.currentLevel]
 		local ss = l.sprites[l.currentLevel]
 		local sn = l.npcs[l.currentLevel]
 		for i = 1, #lvl do

 			if lvl[i].solid then
 				--left
 				if lvl[i].currentTileX == currentX - 1 and lvl[i].currentTileY == currentY then
 					collides[2] = 'l'
 				end
 				--right
 				if lvl[i].currentTileX == currentX + 1 and lvl[i].currentTileY == currentY then
 					collides[4] = 'r'
 				end
 				--up
 				if lvl[i].currentTileY == currentY  - 1 and lvl[i].currentTileX == currentX then
 					collides[1] = 'u'
 				end
 				--down
 				if lvl[i].currentTileY == currentY + 1 and lvl[i].currentTileX == currentX then
 					collides[3] = 'd'
 				end
 			end
 		end
 		for i = 1, #ss do
 			if ss[i].currentTileX == currentX - 1 and ss[i].currentTileY == currentY then
 				collides[2] = 'l'
 			end
 			if ss[i].currentTileX == currentX + 1 and ss[i].currentTileY == currentY then
 				collides[4] = 'r'
 			end
 			if ss[i].currentTileY == currentY - 1 and ss[i].currentTileX == currentX then
 				collides[1] = 'u'
 			end
 			if ss[i].currentTileY == currentY + 1 and ss[i].currentTileX == currentX then
 				collides[3] = 'd'
 			end
 		end

 		for i = 1, #sn do
 			if sn[i].currentTileX == currentX - 1 and sn[i].currentTileY == currentY then
 				collides[2] = 'l'
 			end
 			if sn[i].currentTileX == currentX + 1 and sn[i].currentTileY == currentY then
 				collides[4] = 'r'
 			end
 			if sn[i].currentTileY == currentY - 1 and sn[i].currentTileX == currentX then
 				collides[1] = 'u'
 			end
 			if sn[i].currentTileY == currentY + 1 and sn[i].currentTileX == currentX then
 				collides[3] = 'd'
 			end
 		end
 		return collides
 	end

 	function l:draw(sprites)
 		local lvl = l.levels[l.currentLevel]
 		for t = 1, #lvl do
 			love.graphics.draw(sprites.img,sprites:getSpriteQuad(lvl[t].currentSpriteX,lvl[t].currentSpriteY),lvl[t].x,lvl[t].y)
 		end
 	end
 	function l:drawS(othsprites)
		local ss = l.sprites[l.currentLevel]
 		for s = 1, #ss do
 			ss[s]:draw(othsprites)
 		end
 		local sn = l.npcs[l.currentLevel]
 		for s = 1, #sn do
 			sn[s]:draw(othsprites)
 		end
 	end

 	return l
 end

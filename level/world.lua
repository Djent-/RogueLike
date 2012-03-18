require("level/level")
require("screen/gui")
require("battle/battle")
require("entities/item")

World = {}

function World:new()
	local w = {}

	w.worlds = {}
	w.levels = nil
	w.gui = nil
	w.shadow = nil
	w.currentWorld = 1
	w.battle = nil
	w.isDead = false
	w.gui = nil
	
	function w:load(lvls,spriteMap,npcTypes)
		w.gui = gui:new(0,0)		
		w.levels = Level:new()
		w.battle = Battle:new()
		w.shadow = love.graphics.newImage("assets/shadow.png")
		w.shadow:setFilter("nearest","nearest")

		for i = 1, #lvls do
			local l = Level:new()
			l:createLevel(lvls[i],spriteMap[i],npcTypes)
			table.insert(w.worlds,l)
		end
	end

	function w:update(lvls,spriteMap,npcTypes,dt)
		w.worlds[w.currentWorld].player.currentWorld = w.currentWorld
		w.isDead = w.worlds[w.currentWorld].player.dead
		if not w.battle.inbattle  then
			w.gui:update(w.worlds[w.currentWorld],dt)
			if w.worlds[w.currentWorld].player.health <= 0 then
				w.worlds = {}
				for i = 1, #lvls do
					local l = Level:new()
					l:createLevel(lvls[i],spriteMap[i],npcTypes)
					table.insert(w.worlds,l)
					w.currentWorld = 1
				end
			end
		end
		if not w.battle.inbattle and not w.gui.showInventory and not w.gui.showWeaponWindow then
			w.worlds[w.currentWorld]:update(w.battle,w.worlds[w.currentWorld],dt)
		elseif w.battle.inbattle then
			w.battle:update(dt)
		elseif w.isDead then

		end
	end

	function w:draw(sprites)
		if not w.battle.inbattle then
			w.worlds[w.currentWorld]:draw(sprites[1])
			love.graphics.draw(w.shadow,0,0)
			w.worlds[w.currentWorld]:drawS(sprites[2])
			
			w.gui:draw(w.worlds[w.currentWorld])
		elseif w.battle.inbattle then
			w.battle:render()
		end
	end

	return w
end

require("battle/menu")
require("screen/spritesheet")
require("screen/gui")

Battle = {}

function Battle:new()
	local battle = {}

	--init
	battle.curMen = 0
	battle.selected = 1
	battle.inbattle = false

	battle.player = nil
	battle.enemy = nil
	battle.enemyIndex = nil

	battle.useItem = false
	battle.onTurn = false
	battle.turnUsage = nil
	battle.enemyAttacking = false
	battle.timer = 0
	battle.newTile = nil
	battle.newAttackDmg = nil
	battle.currentAttack = nil
	battle.critChance = nil

	battle.guiElements = {
		{love.graphics.newImage("assets/battlebg.png"),0,0},
		{love.graphics.newImage("assets/battleGui_bottom.png"),GAME_WIDTH - 82,GAME_HEIGHT- 37},
		{love.graphics.newImage("assets/battleGui_top.png"),0,-11},
		{love.graphics.newImage("assets/battleGui_shadow.png"),0,0}
	}
	battle.playerWeps = Spritesheet:new("weapons.png",44,55)
	battle.currentWepX = 0
	battle.currentWepY = 0

	battle.playerimg = love.graphics.newImage("assets/battle_player.png")
	battle.playerimg:setFilter('nearest','nearest')
	battle.enemies = Spritesheet:new("enemy.png",37,41)
	battle.currentEnemyX = 0
	battle.currentEnemyY = 0
	battle.crit = 60

	battle.menus = {
		{"attacks",nil},
		{"abilities",nil},
		{"inventory",nil},
		{"pass",nil},
	}
	for i = 1, #battle.guiElements do
		battle.guiElements[i][1]:setFilter("nearest","nearest")
	end
	battle.gui = Menu:new()

	--funcs
	function battle:engage(player,sprites,enemyIndex)
		battle.inbattle = true
		battle.player = player
		battle.sprites = sprites
		battle.enemy = sprites[enemyIndex]
		battle.enemyIndex = enemyIndex

		battle.menus[1][2] = battle.player.attacks
		battle.menus[2][2] = battle.player.abilities
		battle.menus[3][2] = battle.player.items

		battle.currentEnemyY = battle.enemy.battleY
	end

	function battle:update(dt)
		if battle.inbattle then
			if battle.onTurn then
				battle.gui.render = false
				if battle.newTile == nil then
					battle.newTile = battle.player.attacks[battle.selected].attkImg
				end
				battle.currentWepX = battle.newTile
				if battle.currentAttack == nil then
					battle.currentAttack = battle.selected
				end

				battle:attack(battle.player, battle.enemy, battle.currentAttack,dt)
			end
			if battle.enemyAttacking then
				battle.gui.render = false
				if battle.newTile == nil then
					battle.newTile = math.random(1,2)
				end
				if battle.currentAttack == nil then
					battle.currentAttack = math.random(1,#battle.enemy.attacks)
				end
				battle.currentEnemyX = battle.newTile
				battle:attack(battle.enemy, battle.player, battle.currentAttack, dt)
			end
			if battle.useItem then
				battle:itemUsage()
			end
		end

	end

	function love.keypressed(key)
		if battle.inbattle and not battle.enemyAttacking and not battle.onTurn then
			if key == "down" then
				if battle.curMen > 0 then
					local len = #battle.menus[battle.curMen][2]
					if battle.selected == len then
						battle.selected = len
					else
						battle.selected = battle.selected + 1
					end
				else
					if battle.selected == #battle.menus then
						battle.selected = #battle.menus
					else
						battle.selected = battle.selected + 1
					end
				end
			elseif key == "up" then
				if battle.selected == 1 then 
					battle.selected = 1
				else
					battle.selected = battle.selected - 1
				end
			elseif key == "right" then
				if battle.curMen == 1 then
					battle.onTurn = true
				elseif battle.curMen == 2 then
					-- abilities
				elseif battle.curMen == 3 then
					-- items
					if #battle.menus[battle.curMen][2] > 0 then
						battle.useItem = true
					end
				else
					if battle.selected == 4 then
						battle.enemyAttacking = true
					else
						battle.curMen = battle.selected
						battle.selected = 1
					end
				end
			elseif key == "left" then
				battle.curMen = 0
			end
		end
	end

	function battle:render()
		--gui
		for i = 1, #battle.guiElements do
			local elem = battle.guiElements[i]
			love.graphics.draw(elem[1],elem[2],elem[3])
		end
		--text
		if battle.inbattle then
			Font:start(2)
				Font:print(battle.enemy.name,5,5)
				Font:print(battle.player.name,battle.guiElements[2][2] + 58,battle.guiElements[2][3] + 75)
			Font:stop()

			-- player/enemy
			love.graphics.drawq(battle.playerWeps.img,battle.playerWeps:getSpriteQuad(battle.currentWepX * 43,battle.currentWepY * 43),40,GAME_HEIGHT - 55)
			love.graphics.draw(battle.playerimg,0,GAME_HEIGHT - 63)
			love.graphics.drawq(battle.enemies.img,battle.enemies:getSpriteQuad(battle.currentEnemyX * 37,battle.currentEnemyY * 37),GAME_WIDTH - 60,5)
			--menu
			if battle.curMen > 0 then
				battle.gui:renderItemList(battle.menus[battle.curMen][2],WINDOW_WIDTH - 213,WINDOW_HEIGHT - 50,battle.selected,12,5,4)
			elseif battle.curMen == 0 then
				battle.gui:renderList(battle.menus,WINDOW_WIDTH - 213,WINDOW_HEIGHT - 50,battle.selected,12,5,4)
			end
			gui:renderGhostBar(2,11, 170 / 3)
			gui:renderGhostBar(90,139, 170 / 3)
			gui:renderHealthBar(2,11,battle.enemy.health / 3)
			gui:renderHealthBar(90,139,battle.player.health / 3)

		end
	end

	function battle:attack(attacker, attackee, attackUsed,dt)
		if battle.timer >= 0 then
			battle.timer = battle.timer + dt
			if battle.timer >= 0.5 then
				battle.currentEnemyX = 0
				battle.currentWepX = 0
			end
			if battle.timer >= 1 then 
				--make enemy health go down
				if battle.newAttackDmg == nil then
					if battle.critChance == nil then
						battle.critChance = math.random(0,5)
					end
					print(battle.critChance)
					if battle.critChance == 5 then
						print("crit!")
						battle.newAttackDmg = attackee.health - ((attacker.dmg + attacker.attacks[attackUsed].dmg + battle.crit) - attacker.defense)
					else
						battle.newAttackDmg = attackee.health - ((attacker.dmg + attacker.attacks[attackUsed].dmg) - attacker.defense)
					end
					print("used: " .. attacker.attacks[attackUsed].name)
				end
				if attackee.health >= battle.newAttackDmg then   
					attackee.health = attackee.health - 1
				else
					attackee.health = battle.newAttackDmg

					battle.curMen = 0
					battle.selected = 1
					battle.critChance = nil

					if attackee.health <= 0 then
						battle.timer = 0
						if battle.enemyAttacking then
							battle:lose()
						else
							battle:win()
						end
					end
					if attacker.health <= 0 then
						battle.timer = 0
						if battle.enemyAttacking then
							battle:lose()
						else
							battle:win()
						end
					else
						battle.timer = 0
						battle.newTile = nil
						battle.newAttackDmg = nil
						battle.currentAttack = nil
						battle.gui.render = true
						if attacker == battle.player then
							battle.enemyAttacking = true
						else
							battle.enemyAttacking = false
						end
						battle.onTurn = false
					end
				end			
			end
		end
	end

	function battle:itemUsage()
		local item = battle.player.items[battle.selected]
		if item.health > 0 then
			local newHealth = battle.player.health + item.health
			if newHealth > battle.player.maxHealth then newHealth = battle.player.maxHealth end

			if battle.player.health <= newHealth then
				battle.player.health = battle.player.health + 1
			else
				battle.player.health = newHealth
				--table.remove(battle.menus[battle.curMen],battle.selected)
				print(battle.selected)
				table.remove(battle.player.items,battle.selected)
				battle.curMen = 0
				battle.selected = 1
				battle.useItem = false
				battle.enemyAttacking = true
			end
		end
		--[[
		if item.defense > 0 then
			battle.player.defense = battle.player.defense + item.defense
			local newDef = battle.player.defense + item.defense
			if newDef > 

			if battle.player.defense <= newDef then
				battle.player.defense = battle.player.defense + 1
			else
				battle.player.defense = newDef
				table.remove(battle.player.items,battle.selected)
				battle.useItem = false
				battle.enemyAttacking = true
			end			
		end]]
		
	end

	function battle:win()
		print("winbattle")
		battle.newTile = nil
		battle.newAttackDmg = nil
		battle.currentAttack = nil
		battle.gui.render = true

		battle.enemyAttacking = false
		battle.onTurn = false
		table.remove(battle.sprites,battle.enemyIndex)
		battle.inbattle = false
	end
	function battle:lose()
		battle.newTile = nil
		battle.currentAttack = nil
		battle.newAttackDmg = nil
		battle.gui.render = true

		battle.enemyAttacking = false
		battle.onTurn = false
		battle.inbattle = false
	end
	
	return battle
end




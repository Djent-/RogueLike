require("screen/font")
require("screen/spritesheet")
require("battle/menu")

gui = {}
gui.healthBar = love.graphics.newImage("assets/healthbar.png")
gui.ghostbar = love.graphics.newImage("assets/ghostbar.png")

function gui:new(x,y)
	local g = {}
	g.x = x
	g.y = y
	g.img = love.graphics.newImage("assets/header_gui.png")
	g.invWindow = love.graphics.newImage("assets/inventory_window.png")
	g.invSelector = love.graphics.newImage("assets/inventory_selector.png")
	g.invWindow:setFilter("nearest","nearest")
	g.invSelector:setFilter("nearest","nearest")
	g.img:setFilter("nearest","nearest")
	Font:load()
	g.weaponIcons = Spritesheet:new("weaponIcons.png",16,16)
	g.weaponX = 0
	g.weaponY = 0

	g.showInventory = false
	g.showWeaponWindow = false
	g.invX = 20
	g.invY = 0
	g.invMenu = Menu:new()
	g.invSelect = 1
	g.prevSelect = 1
	g.delta = 0
	g.canClose = false
	g.timer = 0
	g.useItem = false
	g.newHealth = nil

	function g:update(lvl,dt)
		if love.keyboard.isDown("1") and not g.showWeaponWindow then
			if g.showWeaponWindow == false then
				g.invSelect = 1
				g.showWeaponWindow = true
				g.showInventory = false
			end
			return
		end
		if love.keyboard.isDown("escape") then
			if g.showWeaponWindow == true or g.showInventory then
				g.showWeaponWindow = false
				g.showInventory = false
				g.invSelect = 1
			end
			return
		end
		if love.keyboard.isDown("2") and not g.showInventory then
			g.invSelect = 1
			g.showWeaponWindow = false
			g.showInventory = true
		end

		if love.keyboard.isDown("down") and g.prevSelect == g.invSelect and (g.showWeaponWindow or g.showInventory) then
			g.prevSelect = g.invSelect
			g.invSelect = g.invSelect + 1
			if g.showWeaponWindow then
				if g.invSelect > #lvl.player.weapons then
					g.invSelect = #lvl.player.weapons
				end
			elseif g.showInventory then
				if g.invSelect > #lvl.player.items then
					g.invSelect = #lvl.player.items
				end
			end
		end
		if love.keyboard.isDown("up") and g.prevSelect == g.invSelect and (g.showWeaponWindow or g.showInventory) then
			g.prevSelect = g.invSelect
			g.invSelect = g.invSelect - 1
			if g.invSelect < 1 then
				g.invSelect = 1
			end
		end
		if love.keyboard.isDown("right") and (g.showWeaponWindow or g.showInventory)  then
			if g.showWeaponWindow then
				lvl.player.currentWeapon = lvl.player.weapons[g.invSelect]
				lvl.player.attacks = lvl.player.currentWeapon.attacks
				g.weaponX = g.invSelect - 1
			elseif g.showInventory and not g.showWeaponWindow then
				g.useItem = true
			end
		end
		if g.useItem and not g.showWeaponWindow and g.showInventory then
			local item = lvl.player.items[g.invSelect]
			if lvl.player.health < lvl.player.maxHealth then
				if g.newHealth == nil then
					g.newHealth = lvl.player.health + item.health
				end
				if g.newHealth > lvl.player.maxHealth then g.newHealth = lvl.player.maxHealth end
				if lvl.player.health < g.newHealth then
					lvl.player.health = lvl.player.health + 1
				end
				if lvl.player.health >= g.newHealth or lvl.player.health == lvl.player.maxHealth then
					print('used potion')
					lvl.player.health = g.newHealth
					table.remove(lvl.player.items,g.invSelect)
					g.newHealth = nil
					g.invSelect = 1
					g.useItem = false
				end
			end
			print(lvl.player.health)
		end


		if g.prevSelect ~= g.invSelect and g.timer >= 0 then
			g.timer = g.timer + 1
			if g.timer >= 12 then
				g.prevSelect = g.invSelect
				g.timer = 0
			end
		end
	end

	function g:draw(lvl)
		--inventory
		if g.showWeaponWindow then
			love.graphics.draw(g.invWindow, 20,0)
			Font:start(2)
				Font:print("weapons",(g.invX + 20),(g.invX + 10))
			Font:stop()
			g.invMenu:renderItemList(lvl.player.weapons,(g.invX + 5) * 3,(g.invX + 57),g.invSelect,12,5,5)
		elseif g.showInventory then
			love.graphics.draw(g.invWindow, 20,0)
			Font:start(2)
				Font:print("items",(g.invX + 20),(g.invX + 10))
			Font:stop()
			g.invMenu:renderItemList(lvl.player.items,(g.invX + 5) * 3,(g.invX + 57),g.invSelect,12,5,5)
		end

		love.graphics.draw(g.img,g.x,g.y)
		Font:start(2)
			--header
			Font:print(lvl.player.name,(480 / 4) - (Font:getWidth(lvl.player.name) / 2),5)
			gui:renderGhostBar((480 / 4) - 170 / 2,17, 170)
			gui:renderHealthBar((480 / 4) - (lvl.player.health) / 2,17, lvl.player.health)
		Font:stop()


		--weapon icon
		love.graphics.draw(g.weaponIcons.img,g.weaponIcons:getSpriteQuad(g.weaponX * 16,g.weaponY * 16),2,3)
		--score
		Font:start(1)
			Font:print(string.format("score %d",lvl.player.score),24 * 3,10)
		Font:stop()
	end

	return g
end

function gui:renderHealthBar(x,y,size)
	for i = 1, size do
		love.graphics.draw(gui.healthBar,x + (1 * i), y)
	end
end
function gui:renderGhostBar(x,y,size)
	for i = 1, size do
		love.graphics.draw(gui.ghostbar,x + (1 * i), y)
	end
end

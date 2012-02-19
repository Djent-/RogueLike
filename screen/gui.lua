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

	function g:update(player,dt)
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
				if g.invSelect > #player.weapons then
					g.invSelect = #player.weapons
				end
			elseif g.showInventory then
				if g.invSelect > #player.items then
					g.invSelect = #player.items
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
				player.currentWeapon = player.weapons[g.invSelect]
				player.attacks = player.currentWeapon.attacks
				g.weaponX = g.invSelect - 1
			elseif g.showInventory and not g.showWeaponWindow then
				g.useItem = true
			end
		end
		if g.useItem and not g.showWeaponWindow and g.showInventory then
			local item = player.items[g.invSelect]
			if player.health < player.maxHealth then
				local newHealth = player.health + item.health
				if newHealth > player.maxHealth then newHealth = player.maxHealth end
				if player.health < newHealth then
					player.health = player.health + 1
				else
					print('used potion')
					player.health = newHealth
					table.remove(player.items,g.invSelect)
					print(#player.items)
					g.invSelect = 1
					g.useItem = false
				end
			end
		end


		if g.prevSelect ~= g.invSelect and g.timer >= 0 then
			g.timer = g.timer + 1
			if g.timer >= 12 then
				g.prevSelect = g.invSelect
				g.timer = 0
			end
		end
	end

	function g:draw(player)
		--inventory
		if g.showWeaponWindow then
			love.graphics.draw(g.invWindow, 20,0)
			Font:start(2)
				Font:print("weapons",(g.invX + 20),(g.invX + 10))
			Font:stop()
			g.invMenu:renderItemList(player.weapons,(g.invX + 5) * 3,(g.invX + 57),g.invSelect,12,5,5)
		elseif g.showInventory then
			love.graphics.draw(g.invWindow, 20,0)
			Font:start(2)
				Font:print("items",(g.invX + 20),(g.invX + 10))
			Font:stop()
			g.invMenu:renderItemList(player.items,(g.invX + 5) * 3,(g.invX + 57),g.invSelect,12,5,5)
		end

		love.graphics.draw(g.img,g.x,g.y)
		Font:start(2)
			--header
			Font:print(player.name,(480 / 4) - (Font:getWidth(player.name) / 2),5) 
			gui:renderGhostBar((480 / 4) - 170 / 2,17, 170)
			gui:renderHealthBar((480 / 4) - (player.health) / 2,17, player.health)
		Font:stop()

		
		--weapon icon
		love.graphics.drawq(g.weaponIcons.img,g.weaponIcons:getSpriteQuad(g.weaponX * 16,g.weaponY * 16),2,3)

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
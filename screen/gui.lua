require("screen/font")

gui = {}
gui.healthBar = love.graphics.newImage("assets/healthbar.png")
gui.ghostbar = love.graphics.newImage("assets/ghostbar.png")


function gui:new(x,y)
	local g = {}
	g.x = x
	g.y = y
	g.img = love.graphics.newImage("assets/header_gui.png")
	g.img:setFilter("nearest","nearest")
	Font:load()

	function g:update(dt)

	end

	function g:draw(player)
		love.graphics.draw(g.img,g.x,g.y)
		Font:start(2)
			Font:print(player.name,(480 / 4) - (Font:getWidth(player.name) / 2),5) 
			--Font:print(player:healthToString(0),(480 / 4) - (Font:getWidth(player:healthToString(0)) / 2),(g.y))
			gui:renderGhostBar((480 / 4) - 170 / 2,17, 170)
			gui:renderHealthBar((480 / 4) - (player.health) / 2,17, player.health)
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
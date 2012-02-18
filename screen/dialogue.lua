require("screen/font")
Dialogue = {}

function Dialogue:new(x,y,name,msg)
	local d = {}

	d.window = love.graphics.newImage("assets/dialogue_window.png")
	d.window:setFilter("nearest","nearest")
	d.active = false

	d.curMes = 1
	d.delta = 0
	d.name = name
	d.msg = msg

	function d:update(msg,dt)
		d.delta = dt
	end	

	function d:render()
		
		local padding = 5
		local x1 = x + padding
		local y1 = y - d.window:getHeight() - padding
		if d.active then
			love.graphics.draw(d.window,x1,y1)

			Font:start(2)
				Font:print(d.name,x + 12 + padding, y + 33)
			Font:stop()
			Font:start(1)
				for i = 1, #d.msg[d.curMes] do
					local x2 = 8 * 3 + 10
					local y2 = (y1 * 3 + 24) + (12 * i)

					Font:print(d.msg[d.curMes][i],x2,y2,d.delta)
				end
			Font:stop()
		end
	end

	return d
end
Spritesheet = {}

function Spritesheet:new(url,xsize,ysize)
	local ss = {}

	ss.img = love.graphics.newImage("assets/" .. url)
	ss.img:setFilter("nearest","nearest")
	ss.tileSizeX = xsize
	ss.tileSizeY = ysize

	function ss:getSpriteQuad(x,y)
		return love.graphics.newQuad(x,y,ss.tileSizeX,ss.tileSizeY,ss.img:getWidth(),ss.img:getHeight())
	end

	return ss
end
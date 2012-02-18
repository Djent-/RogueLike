Font = {}

Font.img = love.graphics.newImage("assets/font.png")
Font.img:setFilter("nearest","nearest")

Font.strletters = "abcdefghijklmnopqrstuvwxyz !0123456789.,?'\"^#"
Font.timer = 0
Font.scrolling = true
Font.letters = {}
Font.letterSize = 8
Font.scrollSentance = {}
Font.scrollView = {}
function Font:load()
	for i = 1, #Font.strletters do
		local lttrQ = love.graphics.newQuad(Font.letterSize * (i - 1), 0,Font.letterSize,Font.letterSize,Font.img:getWidth(),Font.img:getHeight())
		local letter = {Font.strletters:sub(i,i),lttrQ}
		table.insert(Font.letters,letter)
	end
end

function Font:getLetter(lttr)
	for i = 1, #Font.letters do
		if Font.letters[i][1] == lttr then
			return Font.letters[i]
		end
	end
end

function Font:start(scale)
	love.graphics.pop()
	love.graphics.push()
	love.graphics.scale(scale,scale)	
end

function Font:stop()
	love.graphics.pop()
	love.graphics.push()
	love.graphics.scale(3,3)
end

function Font:print(string,x,y,scale)
	local sentance = {}
	for l = 1, #string do
		local c = string:sub(l,l)
		table.insert(sentance, Font:getLetter(c))
	end
	for i = 1, #sentance do
		love.graphics.drawq(Font.img,sentance[i][2],(i - 1) * Font.letterSize + x, y)
	end
end

function Font:getWidth(str)
	return 8 * #str 
end

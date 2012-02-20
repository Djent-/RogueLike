require("entities/itemmanager")

LevelGen = {}

function LevelGen:new()
	local l = {}
	l.maxWidth = 10
	l.maxHeight = 10
	l.wallTiles = {w,r,z}
	l.goundTiles = {g,h}

	function l:makeTop()
		local top = {}

		for i = 1, l.maxWidth do
			local rand = math.random(1,#l.wallTiles)
			table.insert(top,l.wallTiles[rand])
		end

		return top
	end

	return l
end
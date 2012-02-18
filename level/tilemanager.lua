TileManager = {}



function TileManager:new(x,y)
	local tm = {}
	tm.tileSize = 16
	tm.x = x * tm.tileSize
	tm.y = y * tm.tileSize
	tm.solid = false
	return tm
end

-- ground tile
g = TileManager:new(1,0)
h = TileManager:new(4,0)

-- wall tile
w = TileManager:new(0,0)
r = TileManager:new(1,1)
z = TileManager:new(0,2)
z.solid = true
r.solid = true
w.solid = true

--sidewall
q = TileManager:new(0,1)
q.solid = true

--leftcorner wall
a = TileManager:new(2,0)

--right corner wall
b = TileManager:new(2,1)
--wall down
c = TileManager:new(3,0)

-- wall left
d = TileManager:new(3,1)

-- wall right
e = TileManager:new(4,1)
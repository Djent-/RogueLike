require("screen/spritesheet")
require("level/tilemanager")
require("level/levelmanager")
require("level/world")

WINDOW_WIDTH = 480
WINDOW_HEIGHT = 473
GAME_WIDTH = 16 * 10
GAME_HEIGHT = 16 * 10

local gamePaused = false

local world = nil
local sprites = Spritesheet:new("sprites.png",16,16)
local psprites = Spritesheet:new("playersprites.png",16,16)

function love.load()
	math.randomseed(os.time())
	world = World:new()
	world:load(lvls,spriteMap,npcTypes)
end

function love.update(dt)
	world:update(lvls,spriteMap,npcTypes,dt)
end

function love.draw()
	love.graphics.pop()
	love.graphics.push()
	love.graphics.scale(3,3)

	world:draw({sprites,psprites})
end

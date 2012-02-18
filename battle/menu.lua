require("screen/font")

Menu = {}

function Menu:new()
	local menu = {}
	menu.render = true

	function menu:renderList(items,originX,originY,selected,y1,padding,visibleLength)
		if menu.render then
			Font:start(1)
			if #items > visibleLength then
				for i = selected, #items do
					Font:print(items[i][1],originX + padding,(originY + padding) + (y1 * i -  selected * y1))
				end
				Font:print(" ^",originX + Font:getWidth(items[selected][1]), (originY + padding)+ (selected - 1) - selected)
			else
				for i = 1, #items do
					Font:print(items[i][1],originX + padding,(originY + padding) + (i - 1) * y1)
				end
				if #items > 0 then
					Font:print(" ^",originX + Font:getWidth(items[selected][1]), (originY + padding)+ (selected - 1) * y1)
				else
					Font:print("no items",originX + padding,(originY + padding) + (y1 * 0 * y1))
				end	
			end
			Font:stop()
		end
	end

	function menu:renderItemList(items, originX,originY, selected,y1,padding,visibleLength)
		if menu.render then
			Font:start(1)

			if #items > visibleLength then
				for i = selected, #items do
					Font:print(items[i].name,originX + padding,(originY + padding) + (y1 * i -  selected * y1))
				end
				if #items > 0 then
					Font:print(" ^",originX + Font:getWidth(items[selected].name), (originY + padding)+ (selected - 1) - selected)
				else
					Font:print("no items",originX + padding,(originY + padding) + (y1 * 0 * y1))
				end
			else
				for i = 1, #items do
					Font:print(items[i].name,originX + padding,(originY + padding) + (i - 1) * y1)
				end
				if #items > 0 then
					Font:print(" ^",originX + Font:getWidth(items[selected].name), (originY + padding)+ (selected - 1) * y1)
				else
					Font:print("no items",originX + padding,(originY + padding) + (y1 * 0 * y1))	
				end	
			end
			Font:stop()
		end
	end

	return menu
end
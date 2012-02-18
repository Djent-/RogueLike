Item = {}

function Item:new(name,type, category)
	local i = {}

	i.name = name
	i.dmg = 0
	i.worth = 0
	i.type = type
	i.category = category
	i.regen = 0
	i.battleUsable = bu

	i.attacks = {}

	return i
end
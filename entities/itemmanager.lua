require("entities/item")

attacks = {}
consumables = {}
weapons = {}
abilities = {}

-- attacks
attacks.longSwipe = {name="long swipe", dmg=30,attkImg=2}
attacks.stab = {name="stab",dmg=40,attkImg=3}
attacks.punch = {name="punch",dmg=15,attkImg=1}
attacks.tongue = {name="tongue attack",dmg=10,attkImg=2}

-- weapons
weapons.shortSword = Item:new("short sword","move", "attack")
weapons.shortSword.dmg = 15
weapons.shortSword.worth = 50
weapons.shortSword.attacks = {attacks.longSwipe,attacks.stab}

weapons.karate = Item:new("fist","move","attack")
weapons.karate.dmg = 5
weapons.karate.worth = 0
weapons.karate.attacks = {attacks.punch,attacks.tongue}

-- consumables
consumables.healthPotion = {name="health potion",health=100,defense=0}--Item:new("health potion","consumable","health")
--consumables.defencePotion = {name="elixer of defense",health=0,defense=50}--Item:new("elixer of defense","consumable", "defense")
consumables.chocCandy = {name="chocolate candy",health=50,defense=0}
consumables.mushroom = {name="mushrooms",health=40,defense=10}
-- abilities
abilities.block = {name="block",health=0,defense=50}--Item:new("block","ability","defense")
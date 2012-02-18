require("entities/itemmanager")
-- 10x8 at 480x384
-- tiles at 48x48 (16 * 3)
lvls = {
	{
		{
			{w,r,w,w,w,r,r,w,w,w},
			{r,w,r,w,w,w,r,r,r,w},
			{w,q,q,q,q,q,q,q,q,q},
			{w,d,g,g,g,g,g,g,g,g},
			{r,d,e,q,w,d,g,g,e,r},
			{r,d,g,e,q,d,h,e,w,w},
			{w,d,g,g,h,h,h,e,w,w},
			{r,d,g,h,h,g,e,w,w,w},
			{w,d,h,h,e,w,w,w,w,w},
			{r,w,r,r,r,w,w,r,w,w},
		},
		{
			{w,w,w,r,r,w,w,w,w,w},
			{r,q,z,q,q,w,w,w,r,w},
			{q,g,h,g,e,q,q,q,r,w},
			{g,g,g,g,g,h,g,g,z,r},
			{r,g,g,g,h,g,h,g,e,w},
			{r,g,g,h,g,g,h,h,e,q},
			{w,g,g,g,g,g,h,g,g,g},
			{r,g,g,g,g,g,g,g,e,w},
			{w,g,e,w,d,e,w,d,e,r},
			{w,w,r,w,r,w,w,r,w,w},
		},
		{
			{w,w,w,w,w,w,w,w,w,w},
			{w,w,w,r,q,w,w,w,w,w},
			{w,q,q,w,g,q,q,q,w,w},
			{w,d,e,q,d,g,g,g,w,w},
			{w,d,g,g,g,g,g,g,q,w},
			{q,d,g,g,g,g,g,g,e,w},
			{g,g,g,g,g,e,q,d,e,w},
			{w,d,g,g,g,g,g,g,e,w},
			{w,d,g,g,g,g,g,g,e,w},
			{w,w,w,w,w,w,w,w,w,w},
		}
	}
}
npcTypes = {
	{"goblin",true,{weapons.karate},3,0},
	{"juemba rat",true,{weapons.karate},4,0},
	{"grumbo the wise",false,{},1,0,
		{
			{"don't ask how you got here, i have no idea. but",
			 "there's probably something helpful in that chest."},
		}
	},
	{"grandelf the graw",false,{},1,0,
		{
			{"as you can see, the \"arrow keys\" do most of the",
			 "work. you can press \"w\" for your weapons, and ",
			 "press \"e\" for your inventory."},
		}
	},
	{"counselor chauncey",false,{},1,0,
		{
			{"i'm glad you're here, there is evil in this land.",
			 "three \"stones of sorrow\" you must retrieve, collect",
			 "the stones, then your path will be clear."}
	    }
	},

}

spriteMap = 
{
	{
		{
			{0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,1,0},
			{0,0,0,0,0,0,0,0,0},
			{0,0,3,0,0,0,0,0,0},
			{0,0,0,0,0,1,0,0,0},
			{0,0,0,0,0,0,0,0,0},
		},
		{
			{0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,4,0,0},
			{0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,1,0,0},
			{0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0},
		},
		{
			{0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,5,0,0,0},
			{0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0},
		}
	}
}
extends Node

enum STORY_ITEM { CONTROLS_1, CONTROLS_2, CONTROLS_3 }

func get_story(item: STORY_ITEM) -> String:
	match item:
		STORY_ITEM.CONTROLS_1:
			return "There once was a chicken that knew\nto move left [A] and right [D]"
		STORY_ITEM.CONTROLS_2:
			return "The chicken could also jump [SPACE]!"
		STORY_ITEM.CONTROLS_3:
			return "And trying VERY hard,\nshe could jump again while mid-jump!"
		
	return ""

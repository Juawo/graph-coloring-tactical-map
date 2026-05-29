extends Node2D

var base_type : GameEnum.BaseTypes : set = set_base_type

func set_base_type(new_value : GameEnum.BaseTypes) -> void :
	base_type = new_value
	match new_value :
		GameEnum.BaseTypes.HEAL : modulate = Color.SEA_GREEN
		GameEnum.BaseTypes.WEAPONS : modulate = Color.YELLOW 
		GameEnum.BaseTypes.FUEL : modulate = Color.DEEP_SKY_BLUE
		GameEnum.BaseTypes.COMMAND_CENTER : modulate = Color.DARK_RED

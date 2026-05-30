extends Node2D

var base_type : GameEnum.BaseTypes : set = set_base_type
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	set_base_type(base_type)
	animation_player.play("spawn")

func set_base_type(new_value : GameEnum.BaseTypes) -> void :
	base_type = new_value
	match new_value :
		GameEnum.BaseTypes.HEAL : sprite_2d.texture = preload("uid://dooc2cepohqkl")
		GameEnum.BaseTypes.WEAPONS : sprite_2d.texture = preload("uid://cnfrmyc2f0qkl")
		GameEnum.BaseTypes.FUEL : sprite_2d.texture = preload("uid://dfjsk65ctxhny")
		GameEnum.BaseTypes.COMMAND_CENTER : sprite_2d.texture = preload("uid://ckwl6ext8c84k")

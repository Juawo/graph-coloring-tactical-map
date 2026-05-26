extends Node2D

var base_node : PackedScene = preload("res://scenes/base_node.tscn")
@export var distance_to_click : float = 20.0

var list_base : Array = []

func _input(event: InputEvent) -> void:
	match_click(event)

func match_click(event : InputEvent) -> void :
	if event is InputEventMouseButton :
		if event.pressed:
			match  event.button_index:
				MOUSE_BUTTON_LEFT:
					var node = base_node.instantiate()
					node.position = event.position
					add_child(node)
					list_base.append(node)
				
				MOUSE_BUTTON_RIGHT:
					for base in list_base :
						if event.position.distance_to(base.position) < distance_to_click :
							base.queue_free()
							list_base.erase(base)
							break

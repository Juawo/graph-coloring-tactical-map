extends Node2D

var base_node : PackedScene = preload("res://scenes/base_node.tscn")

@export var distance_to_click : float = 20.0
@export var min_edge_distance : float = 100.0

var list_base : Array = []
var graph_data : Dictionary = { }

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
					queue_redraw()
					
				
				MOUSE_BUTTON_RIGHT:
					for base in list_base :
						if event.position.distance_to(base.position) < distance_to_click :
							base.queue_free()
							list_base.erase(base)
							queue_redraw()
							break
			organize_graph_types()
			
func _draw() -> void:
	connect_nodes(list_base)

func connect_nodes(node_list : Array) -> void :
	graph_data.clear()
	for node in node_list :
		graph_data[node] = []
	
	for i in range(node_list.size()) :
		for j in range(i + 1,node_list.size()):
			var node_a = node_list[i]
			var node_b = node_list[j]
			
			if node_a.position.distance_to(node_b.position) <= min_edge_distance :
				draw_line(node_a.position, node_b.position, Color.BLACK, 3)
				graph_data[node_a].append(node_b)
				graph_data[node_b].append(node_a)

func organize_graph_types() -> void :
	var graph_calculated = GraphCalculator.calculate_graph_type(graph_data)
	for node in graph_calculated.keys():
		node.set_base_type(graph_calculated[node])

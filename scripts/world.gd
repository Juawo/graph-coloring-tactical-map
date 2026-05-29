extends Node2D

var base_node : PackedScene = preload("res://scenes/base_node.tscn")

@export var distance_to_click : float = 20.0
@export var min_edge_distance : float = 100.0
@export var max_connections : int = 8
@export var min_distance_between_nodes : float = 40
@export var max_node : int = 20

var list_base : Array = []
var graph_data : Dictionary = { }

func _input(event: InputEvent) -> void:
	match_click(event)

func match_click(event : InputEvent) -> void :
	if event is InputEventMouseButton :
		if event.pressed:
			match  event.button_index:
				MOUSE_BUTTON_LEFT:
					if graph_data.size() >= max_node:
						return
					if !verify_min_distance_between_nodes(graph_data, event.position):
						return
					var node = base_node.instantiate()
					node.position = event.position
					add_child(node)
					list_base.append(node)
					
					connect_nodes(list_base)
					organize_graph_types()
					queue_redraw()
	
				MOUSE_BUTTON_RIGHT:
					for base in list_base :
						if event.position.distance_to(base.position) < distance_to_click :
							base.queue_free()
							list_base.erase(base)
							connect_nodes(list_base)
							organize_graph_types()
							queue_redraw()
							break
			
func _draw() -> void:
	for node in graph_data.keys():
		for neighbor in graph_data[node]:
			draw_line(node.position, neighbor.position, Color.BLACK, 3)

func connect_nodes(node_list : Array) -> void :
	graph_data.clear()
	for node in node_list :
		graph_data[node] = []
	
	for i in range(node_list.size()) :
		for j in range(i + 1,node_list.size()):
			var node_a = node_list[i]
			var node_b = node_list[j]
			
			if node_a.position.distance_to(node_b.position) <= min_edge_distance :
				if graph_data[node_a].size() < max_connections and graph_data[node_b].size() < max_connections :
					graph_data[node_a].append(node_b)
					graph_data[node_b].append(node_a)

func organize_graph_types() -> void :
	var graph_calculated = GraphCalculator.calculate_graph_type(graph_data)
	for node in graph_calculated.keys():
		node.set_base_type(graph_calculated[node])

func verify_min_distance_between_nodes(node_list : Dictionary, new_position : Vector2) -> bool :
	for node in node_list.keys() :
		if node.position.distance_to(new_position) <= min_distance_between_nodes:
			return false
	return true

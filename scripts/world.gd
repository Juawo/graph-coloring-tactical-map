extends Node2D

var base_node : PackedScene = preload("res://scenes/base_node.tscn")
var road_scne : PackedScene = preload("res://scenes/road.tscn")

@export var distance_to_click : float = 40.0
@export var min_edge_distance : float = 300.0
@export var max_connections : int = 5
@export var min_distance_between_nodes : float = 80
@export var max_node : int = 20

@onready var road_container: Node2D = $RoadContainer
@onready var camera_2d: Camera2D = $Camera2D

var is_dragging_camera : bool
var is_mouse_clicked : bool = false

var list_base : Array = []
var graph_data : Dictionary = { }

func _input(event: InputEvent) -> void:
	match_click(event)
	if event is InputEventKey:
		if event.keycode == KEY_SPACE:
			is_dragging_camera = event.pressed
			
	if event is InputEventMouseMotion and is_dragging_camera and is_mouse_clicked:
		camera_2d.position -= event.relative
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			# Dá zoom aproximando (aumenta a escala da câmera)
			# clamp evita que o usuário dê zoom infinito e quebre o visual
			camera_2d.zoom = clamp(camera_2d.zoom + Vector2(0.1, 0.1), Vector2(0.5, 0.5), Vector2(2.0, 2.0))
			
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			# Dá zoom afastando (diminui a escala da câmera)
			camera_2d.zoom = clamp(camera_2d.zoom - Vector2(0.1, 0.1), Vector2(0.5, 0.5), Vector2(2.0, 2.0))


func match_click(event : InputEvent) -> void :
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_LEFT :
			is_mouse_clicked = event.pressed
		if event.pressed:
			match  event.button_index:
				MOUSE_BUTTON_LEFT:
					if is_dragging_camera :
						return
					if graph_data.size() >= max_node:
						return
					if !verify_min_distance_between_nodes(graph_data, get_global_mouse_position()):
						return
					var node = base_node.instantiate()
					node.position = get_global_mouse_position()
					add_child(node)
					list_base.append(node)
					
					connect_nodes(list_base)
					organize_graph_types()
					queue_redraw()
	
				MOUSE_BUTTON_RIGHT:
					for base in list_base :
						if get_global_mouse_position().distance_to(base.position) < distance_to_click :
							base.queue_free()
							list_base.erase(base)
							connect_nodes(list_base)
							organize_graph_types()
							queue_redraw()
							break

func _draw() -> void:
	for node in graph_data.keys():
		for neighbor in graph_data[node]:
			var scene = road_scne.instantiate()
			road_container.add_child(scene)
			scene.set_road(node.position, neighbor.position)

func connect_nodes(node_list : Array) -> void :
	graph_data.clear()
	for child in road_container.get_children() :
		child.queue_free()
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

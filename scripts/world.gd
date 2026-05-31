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
@onready var limit_options: Control = $CanvasLayer/limit_options
@onready var totals: Control = $CanvasLayer/totals

var is_dragging_camera : bool
var is_mouse_clicked : bool = false

var list_base : Array = []
var graph_data : Dictionary = { }

# No _ready() do seu World.gd, conecte os sinais vindo do CanvasLayer:
func _ready() -> void:
	# Exemplo conectando via código apontando para o caminho correto do seu CanvasLayer
	limit_options.limit_node_changed.connect(_on_max_nodes_changed)
	limit_options.limit_roads_changed.connect(_on_max_roads_changed)
	limit_options.limit_min_edge_changed.connect(_on_min_edge_changed)
	limit_options.limit_min_distance_changed.connect(_on_min_distance_changed)
	update_ui_totals()
# Funções que vão receber os dados e recalcular o grafo:

func _on_max_nodes_changed(new_value: int) -> void:
	max_node = new_value
	
	# Enquanto o total de nós na tela for maior que o novo limite do slider...
	while list_base.size() > max_node:
		# Pegamos o último nó adicionado (o da ponta da lista)
		var node_para_deletar = list_base.back()
		
		# Removemos ele da árvore da Godot
		node_para_deletar.queue_free()
		# Apagamos a referência dele da nossa lista
		list_base.erase(node_para_deletar)
	
	# Depois que o terreno foi limpo, rodamos o recálculo completo do grafo restante
	recalculate_everything()
	
func _on_max_roads_changed(new_value: int) -> void:
	max_connections = new_value
	# Mudar o limite de conexões afeta diretamente o grafo! Precisamos recalcular:
	recalculate_everything()

func _on_min_edge_changed(new_value: int) -> void:
	min_edge_distance = new_value
	# Mudar o alcance de conexão afeta diretamente o desenho! Precisamos recalcular:
	recalculate_everything()

func _on_min_distance_changed(new_value: int) -> void:
	min_distance_between_nodes = new_value
	# Mudar a distância mínima entre nós não altera quem já está na tela, 
	# apenas dita a regra para os próximos cliques de criação.

# Função utilitária para não repetir código
func recalculate_everything() -> void:
	connect_nodes(list_base)
	organize_graph_types()
	queue_redraw()
	update_ui_totals() # Próximo passo abaixo

func update_ui_totals() -> void:
	var total_heal = 0
	var total_bullet = 0
	var total_fuel = 0
	var total_command = 0
	
	# Percorremos todas as bases vivas para contar seus tipos atuais
	for node in list_base:
		match node.base_type:
			GameEnum.BaseTypes.HEAL: total_heal += 1
			GameEnum.BaseTypes.WEAPONS: total_bullet += 1 # Ajuste se o enum for BULLET
			GameEnum.BaseTypes.FUEL: total_fuel += 1
			GameEnum.BaseTypes.COMMAND_CENTER: total_command += 1
			
	# Enviamos os dados fresquinhos direto para a nossa interface
	totals.update_totals(
		list_base.size(), 
		total_heal, 
		total_bullet, 
		total_fuel, 
		total_command
	)

func _unhandled_input(event: InputEvent) -> void:
	match_click(event)
	if event is InputEventKey:
		if event.keycode == KEY_SPACE:
			is_dragging_camera = event.pressed
			
	if event is InputEventMouseMotion and is_dragging_camera and is_mouse_clicked:
		camera_2d.position -= event.relative
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera_2d.zoom = clamp(camera_2d.zoom + Vector2(0.1, 0.1), Vector2(0.5, 0.5), Vector2(2.0, 2.0))
			
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
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
					update_ui_totals()
					queue_redraw()
	
				MOUSE_BUTTON_RIGHT:
					for base in list_base :
						if get_global_mouse_position().distance_to(base.position) < distance_to_click :
							base.queue_free()
							list_base.erase(base)
							connect_nodes(list_base)
							organize_graph_types()
							queue_redraw()
							update_ui_totals()
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

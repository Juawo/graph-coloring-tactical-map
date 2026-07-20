extends Node2D

# Precarregamento das cenas das bases e estradas para instanciação dinâmica
var base_node : PackedScene = preload("res://scenes/base_node.tscn")
var road_scne : PackedScene = preload("res://scenes/road.tscn")

# Parâmetros de configuração e limites do mapa/grafo
@export var distance_to_click : float = 40.0
@export var min_edge_distance : float = 300.0
@export var max_connections : int = 5
@export var min_distance_between_nodes : float = 80
@export var max_node : int = 20

# Referências para nós da cena (Contêineres, Câmeras e UI)
@onready var road_container: Node2D = $RoadContainer
@onready var camera_2d: Camera2D = $Camera2D
@onready var limit_options: Control = $CanvasLayer/limit_options
@onready var totals: Control = $CanvasLayer/totals

# Variáveis de controle de estado e entrada de usuário
var is_dragging_camera : bool
var is_mouse_clicked : bool = false

# Estruturas de dados principais: lista de instâncias e Lista de Adjacência do Grafo
var list_base : Array = []
var graph_data : Dictionary = { }

# Função de inicialização: conecta os sinais de UI para atualizar o grafo em tempo real
func _ready() -> void:
	limit_options.limit_node_changed.connect(_on_max_nodes_changed)
	limit_options.limit_roads_changed.connect(_on_max_roads_changed)
	limit_options.limit_min_edge_changed.connect(_on_min_edge_changed)
	limit_options.limit_min_distance_changed.connect(_on_min_distance_changed)
	update_ui_totals()

# Callback quando o limite máximo de nós é alterado pelo Slider
func _on_max_nodes_changed(new_value: int) -> void:
	max_node = new_value
	
	# Remove os nós excedentes da lista quando o limite diminui
	while list_base.size() > max_node:
		var node_para_deletar = list_base.back()
		node_para_deletar.remove() # Executa a limpeza própria da base
		list_base.erase(node_para_deletar) # Remove da lista do script
	
	recalculate_everything() # Recalcula as arestas e coloração com as bases restantes

# Callback quando o limite máximo de conexões (grau máximo) é alterado
func _on_max_roads_changed(new_value: int) -> void:
	max_connections = new_value
	recalculate_everything()

# Callback quando o alcance/distância máxima da aresta é alterado
func _on_min_edge_changed(new_value: int) -> void:
	min_edge_distance = new_value
	recalculate_everything()

# Callback quando a distância mínima entre nós é alterada na UI
func _on_min_distance_changed(new_value: int) -> void:
	min_distance_between_nodes = new_value

# Função centralizadora para reprocessar a topologia e a coloração do grafo
func recalculate_everything() -> void:
	connect_nodes(list_base) # Reconecta as arestas
	organize_graph_types() # Executa o algoritmo guloso de coloração
	queue_redraw() # Solicita o redesenho visual no engine
	update_ui_totals() # Atualiza os contadores na interface

# Atualiza na interface do usuário a contagem de cada tipo de base (cor)
func update_ui_totals() -> void:
	var total_heal = 0
	var total_bullet = 0
	var total_fuel = 0
	var total_command = 0
	
	# Mapeia e incrementa os totais com base na propriedade atribuída a cada nó
	for node in list_base:
		match node.base_type:
			GameEnum.BaseTypes.HEAL: total_heal += 1
			GameEnum.BaseTypes.WEAPONS: total_bullet += 1
			GameEnum.BaseTypes.FUEL: total_fuel += 1
			GameEnum.BaseTypes.COMMAND_CENTER: total_command += 1
			
	# Envia os dados consolidados para o painel de UI
	totals.update_totals(
		list_base.size(), 
		total_heal, 
		total_bullet, 
		total_fuel, 
		total_command
	)

# Processa entradas de teclado e mouse não consumidas pela UI
func _unhandled_input(event: InputEvent) -> void:
	match_click(event)
	
	# Verifica estado da tecla ESPAÇO para arrasto de câmera
	if event is InputEventKey:
		if event.keycode == KEY_SPACE:
			is_dragging_camera = event.pressed
			
	# Processa movimento de arrasto da câmera
	if event is InputEventMouseMotion and is_dragging_camera and is_mouse_clicked:
		camera_2d.position -= event.relative
	
	# Processa o zoom da câmera via Scroll do mouse
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera_2d.zoom = clamp(camera_2d.zoom + Vector2(0.1, 0.1), Vector2(0.5, 0.5), Vector2(2.0, 2.0))
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera_2d.zoom = clamp(camera_2d.zoom - Vector2(0.1, 0.1), Vector2(0.5, 0.5), Vector2(2.0, 2.0))

# Gerencia os cliques de criação e deleção de nós no mundo
func match_click(event : InputEvent) -> void :
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_LEFT :
			is_mouse_clicked = event.pressed
		if event.pressed:
			match  event.button_index:
				MOUSE_BUTTON_LEFT:
					# Validações antes da inserção do nó
					if is_dragging_camera :
						return
					if graph_data.size() >= max_node:
						return
					if !verify_min_distance_between_nodes(graph_data, get_global_mouse_position()):
						return
					
					# Instanciação do nó na posição do clique
					var node = base_node.instantiate()
					node.position = get_global_mouse_position()
					add_child(node)
					list_base.append(node)
					
					# Atualização do grafo e feedback sonoro/visual
					connect_nodes(list_base)
					organize_graph_types()
					update_ui_totals()
					AudioManager.play_vfx(AudioManager.CLICK_001)
					queue_redraw()
	
				MOUSE_BUTTON_RIGHT:
					# Varre as bases para identificar qual foi clicada para remoção
					for base in list_base :
						if get_global_mouse_position().distance_to(base.position) < distance_to_click :
							base.remove()
							list_base.erase(base)
							connect_nodes(list_base)
							organize_graph_types()
							AudioManager.play_vfx(AudioManager.CLICK_002)
							queue_redraw()
							update_ui_totals()
							break

# Renderiza visualmente as arestas (estradas) conectando os vértices
func _draw() -> void:
	for node in graph_data.keys():
		for neighbor in graph_data[node]:
			var scene = road_scne.instantiate()
			road_container.add_child(scene)
			scene.set_road(node.position, neighbor.position)

# Constrói a Lista de Adjacência com base nas restrições de distância e grau máximo
func connect_nodes(node_list : Array) -> void :
	graph_data.clear() # Reseta a estrutura do grafo
	
	# Limpa instâncias visuais antigas das estradas
	for child in road_container.get_children() :
		child.queue_free()
		
	# Inicializa as chaves do dicionário para todos os vértices
	for node in node_list :
		graph_data[node] = []
	
	# Checagem par a par (força bruta para construção das arestas)
	for i in range(node_list.size()) :
		for j in range(i + 1, node_list.size()):
			var node_a = node_list[i]
			var node_b = node_list[j]
			
			# Cria a aresta se a distância for menor que o limite e não exceder o grau máximo
			if node_a.position.distance_to(node_b.position) <= min_edge_distance :
				if graph_data[node_a].size() < max_connections and graph_data[node_b].size() < max_connections :
					graph_data[node_a].append(node_b) # Adiciona adjacência bidirecional
					graph_data[node_b].append(node_a)

# Chama o resolvedor do grafo e aplica o tipo/cor calculado para cada nó da tela
func organize_graph_types() -> void :
	var graph_calculated = GraphCalculator.calculate_graph_type(graph_data)
	for node in graph_calculated.keys():
		node.set_base_type(graph_calculated[node])

# Função utilitária que garante o espaçamento mínimo entre vértices no mapa
func verify_min_distance_between_nodes(node_list : Dictionary, new_position : Vector2) -> bool :
	for node in node_list.keys() :
		if node.position.distance_to(new_position) <= min_distance_between_nodes:
			return false # Posição inválida (muito próxima)
	return true # Posição válida

extends Control
# No topo do seu LimitOptions.gd:
signal limit_node_changed(new_value: int)
signal limit_roads_changed(new_value: int)
signal limit_min_distance_changed(new_value: int)
signal limit_min_edge_changed(new_value: int)

@onready var total_node_value: Label = $FoldableContainer/ScrollContainer/MarginContainer/VBoxContainer/total_node_limit/MarginContainer/VBoxContainer/HBoxContainer/total_node_value
@onready var max_roads_value: Label = $FoldableContainer/ScrollContainer/MarginContainer/VBoxContainer/max_roads_limit/MarginContainer/VBoxContainer/HBoxContainer/max_roads_value
@onready var min_distance_value: Label = $FoldableContainer/ScrollContainer/MarginContainer/VBoxContainer/min_distance_node/MarginContainer/VBoxContainer/HBoxContainer/min_distance_value
@onready var min_edge_value: Label = $FoldableContainer/ScrollContainer/MarginContainer/VBoxContainer/min_edge_distance/MarginContainer/VBoxContainer/HBoxContainer/min_edge_value

# Dentro das suas funções de slider, emita o sinal correspondente:
func _on_total_node_slider_value_changed(value: float) -> void:
	total_node_value.text = str(int(value))
	limit_node_changed.emit(int(value)) # Dispara avisando quem estiver escutando

func _on_max_roads_slider_value_changed(value: float) -> void:
	max_roads_value.text = str(int(value))
	limit_roads_changed.emit(int(value))

func _on_min_distance_slider_value_changed(value: float) -> void:
	min_distance_value.text = str(int(value))
	limit_min_distance_changed.emit(int(value))

func _on_min_edge_slider_value_changed(value: float) -> void:
	min_edge_value.text = str(int(value))
	limit_min_edge_changed.emit(int(value))

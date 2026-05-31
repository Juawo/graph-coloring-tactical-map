extends Control

@onready var total_value: Label = $PanelContainer/VBoxContainer/total/total_value
@onready var heal_value: Label = $PanelContainer/VBoxContainer/HBoxContainer2/VBoxContainer/heal/heal_value
@onready var bullet_value: Label = $PanelContainer/VBoxContainer/HBoxContainer2/VBoxContainer/bullet/bullet_value
@onready var fuel_value: Label = $PanelContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/fuel/fuel_value
@onready var command_value: Label = $PanelContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/command/command_value

func _ready() -> void:
	update_totals(8,2,2,2,2)

func update_totals(total_nodes : int, total_heal : int, total_bullet : int, total_fuel : int, total_command : int) -> void :
	total_value.text = str(total_nodes)
	heal_value.text = ": " + str(total_heal)
	bullet_value.text = ": " + str(total_bullet)
	fuel_value.text =  ": " + str(total_fuel)
	command_value.text = ": " + str(total_command)

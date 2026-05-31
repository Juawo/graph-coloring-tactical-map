extends Button

func _on_pressed() -> void:
	AudioManager.play_vfx(AudioManager.BACK001)
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

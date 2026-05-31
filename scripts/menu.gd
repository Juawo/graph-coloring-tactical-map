extends Control


func _on_play_btn_pressed() -> void:
	AudioManager.play_vfx(AudioManager.BACK001)
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_exit_btn_pressed() -> void:
	get_tree().quit()

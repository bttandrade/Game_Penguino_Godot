extends Control

func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/spring.tscn")
	
func _on_continue_btn_pressed() -> void:
	pass

func _on_credits_btn_pressed() -> void:
	pass

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

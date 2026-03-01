extends Node

@onready var dialog_box_scene = preload("res://entities/dialog_box.tscn")

var message_lines: Array[String] = []
var current_line = 0
var dialog_box 
var dialog_box_position = Vector2.ZERO
var is_message_active = false
var can_advance_message = false

func start_message(position: Vector2, lines: Array[String]):
	if is_message_active:
		return
	message_lines = lines
	dialog_box_position = position
	show_text()
	is_message_active = true

func show_text():
	dialog_box = dialog_box_scene.instantiate()
	dialog_box.text_display_finished.connect(_on_all_text_displayed)
	get_tree().root.add_child(dialog_box)
	dialog_box.global_position = dialog_box_position
	dialog_box.display_text(message_lines[current_line])
	can_advance_message = false

func _on_all_text_displayed():
	can_advance_message = true

func _unhandled_input(_event: InputEvent) -> void:
	if (Input.is_action_just_pressed("interact") and is_message_active and can_advance_message) and !get_parent().has_node("GameOver"):
		if is_instance_valid(dialog_box):
			dialog_box.queue_free()
		current_line += 1
		if current_line >= message_lines.size() and Globals.finished_the_game:
			await get_tree().create_timer(1.0).timeout
			get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
			return
		elif current_line >= message_lines.size():
			is_message_active = false
			current_line = 0
			return
		show_text()

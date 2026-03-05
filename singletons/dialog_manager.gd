extends Node

@onready var dialog_box_scene = preload("res://entities/dialog_box.tscn")

var message_lines: Array[String] = []
var current_line = 0
var dialog_box 
var dialog_box_position = Vector2.ZERO
var is_message_active = false
var can_advance_message = false

signal game_has_ended()

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("interact") and is_message_active and can_advance_message):
		if is_instance_valid(dialog_box):
			dialog_box.queue_free()
		current_line += 1
		if current_line >= message_lines.size() and Globals.finished_the_game:
			current_line = 0
			var canvas_end = get_tree().current_scene.get_node("HUDs").get_node("CanvasEnd")
			canvas_end.visible = true
			emit_signal("game_has_ended")
			return
		elif current_line >= message_lines.size():
			is_message_active = false
			current_line = 0
			return
		show_text()

func start_message(position: Vector2, lines: Array[String]):
	if is_message_active or lines.is_empty():
		return
	current_line = 0
	message_lines = lines
	dialog_box_position = position
	is_message_active = true
	show_text()

func show_text():
	dialog_box = dialog_box_scene.instantiate()
	dialog_box.text_display_finished.connect(_on_all_text_displayed)
	get_tree().root.add_child(dialog_box)
	dialog_box.global_position = dialog_box_position
	dialog_box.display_text(message_lines[current_line])
	can_advance_message = false

func _on_all_text_displayed():
	can_advance_message = true

func end_message():
	if is_instance_valid(dialog_box):
		dialog_box.queue_free()
	is_message_active = false
	current_line = 0

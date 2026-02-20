extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var sign_area: Area2D = $SignArea

@export var lines: Array[String] = []

func _unhandled_input(event: InputEvent) -> void:
	if sign_area.get_overlapping_bodies().size() > 0:
		sprite.show()
		if event.is_action_pressed("interact") and !DialogManager.is_message_active:
			DialogManager.start_message(global_position, lines)
	else:
		sprite.hide()
		if DialogManager.dialog_box != null:
			DialogManager.dialog_box.queue_free()
			DialogManager.is_message_active = false

func _on_sign_area_body_entered(_body: Node2D) -> void:
	sprite.show()

func _on_sign_area_body_exited(_body: Node2D) -> void:
	sprite.hide()

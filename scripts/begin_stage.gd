extends Node2D

@onready var canvas_name: CanvasLayer = $HUDs/CanvasName
@onready var color_rect: ColorRect = $HUDs/CanvasName/ColorRect
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	canvas_name.visible = true
	player.control_lock = true
	await get_tree().create_timer(0.5).timeout
	player.control_lock = false
	if get_tree().current_scene.name == "Summer1":
		Globals.max_jump_count = 2
	if get_tree().current_scene.name == "Autumn1":
		Globals.can_wall = true

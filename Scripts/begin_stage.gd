extends Node2D

@onready var stage_name: CanvasLayer = $StageName
@onready var color_rect: ColorRect = $StageName/ColorRect
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	stage_name.visible = true
	player.control_lock = true
	await get_tree().create_timer(0.5).timeout
	player.control_lock = false

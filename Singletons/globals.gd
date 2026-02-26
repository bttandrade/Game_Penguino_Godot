extends Node

var player_coins = 0
var player_score = 0
var player_life = 3
var player = null
var current_checkpoint: Vector2 = Vector2.ZERO

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func respawn_player():
	player_life -= 1
	
	if player_life <= 0:
		restart()
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
		return
		
	if current_checkpoint != Vector2.ZERO:
		player.position = current_checkpoint

func restart():
	player_score = 0
	player_coins = 0
	player_life = 3

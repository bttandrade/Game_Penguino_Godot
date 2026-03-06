extends Node

var finished_the_game = false
var player_coins = 0
var player_score: int = 0
var player_life = 6
var player = null
var max_jump_count = 1
var can_wall = false
var can_pause = true
var current_checkpoint: Vector2 = Vector2.ZERO

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func respawn_player():
	player_life -= 1
	
	if player_life <= 0:
		restart()
		var canvas_end = get_tree().current_scene.get_node("HUDs").get_node("CanvasEnd")
		canvas_end.visible = true
		return
		
	if current_checkpoint != Vector2.ZERO and player:
		player.global_position = current_checkpoint

func restart():
	finished_the_game = false
	player_score = 0
	player_coins = 0
	player_life = 6
	max_jump_count = 1
	can_wall = false

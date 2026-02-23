extends Node

var player_coins = 0
var player_score = 0
var player_life = 3
var player = null
var current_checkpoint: Vector2 = Vector2.ZERO

func respawn_player():
	player_life -= 1
	
	if player_life <= 0:
		player_score = 0
		player_coins = 0
		player_life = 3
		get_tree().reload_current_scene()
		return
		
	if current_checkpoint != Vector2.ZERO:
		player.position = current_checkpoint

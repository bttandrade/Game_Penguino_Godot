extends Area2D

@onready var anima: AnimatedSprite2D = $AnimatedSprite2D
@onready var coin_sound: AudioStreamPlayer = $CoinSound

var coin_value = 1

func _on_body_entered(_body: Node2D) -> void:
	coin_sound.play()
	anima.play("collect")
	Globals.player_coins += coin_value
	set_collision_mask_value(2, false)

func _on_animated_sprite_2d_animation_finished() -> void:
	if get_parent() is RigidBody2D:
		get_parent().queue_free()
	else:
		queue_free()

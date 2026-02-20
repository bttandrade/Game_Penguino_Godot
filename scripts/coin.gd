extends Area2D

@onready var anima: AnimatedSprite2D = $AnimatedSprite2D

func _on_body_entered(_body: Node2D) -> void:
	anima.play("collect")

func _on_animated_sprite_2d_animation_finished() -> void:
	if get_parent() is RigidBody2D:
		get_parent().queue_free()
	else:
		queue_free()

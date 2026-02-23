extends Area2D

@onready var anima: AnimatedSprite2D = $AnimatedSprite2D

var is_active = false

func _on_body_entered(body: Node2D) -> void:
	if !body.is_in_group("player_body") or is_active:
		return
	activate_checkpoint()

func activate_checkpoint():
	Globals.current_checkpoint = self.global_position
	is_active = true
	anima.play("raising")

func _on_animated_sprite_2d_animation_finished() -> void:
	if anima.animation == "raising":
		anima.play("checked")

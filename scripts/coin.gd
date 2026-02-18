extends Area2D

@onready var anima: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _on_body_entered(_body: Node2D) -> void:
	anima.play("collect")

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()

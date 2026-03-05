extends Area2D

@onready var anima: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var life_sound: AudioStreamPlayer = $LifeSound

func _ready() -> void:
	anima.visible = false

func _on_body_entered(_body: Node2D) -> void:
	sprite.queue_free()
	anima.visible = true
	life_sound.play()
	anima.play("collect")
	Globals.player_life += 1
	set_collision_mask_value(2, false)

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()

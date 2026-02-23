extends AnimatableBody2D

@export var timer_value = 2

@onready var respawn_timer: Timer = $RespawnTimer
@onready var anima: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var velocity = Vector2.ZERO
var is_triggered = false
var respawn_position = Vector2.ZERO

func _ready() -> void:
	set_physics_process(false)
	respawn_position = global_position

func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	position  += velocity * delta

func _on_stepped_area_entered(area: Area2D) -> void:
	if area.name == "StompBox":
		is_triggered = true
		anima.play("shake")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	set_physics_process(true)
	respawn_timer.start(timer_value)

func _on_respawn_timer_timeout() -> void:
	velocity.y = 0
	set_physics_process(false)
	global_position = respawn_position
	if is_triggered:
		var spawn_tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
		spawn_tween.tween_property(sprite, "scale", Vector2(1, 1), 0.2).from(Vector2(0, 0))
	is_triggered = false

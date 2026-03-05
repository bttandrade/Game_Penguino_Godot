extends CharacterBody2D

enum TotemState{
	walk,
	dead
}

@export var initial_direction = 0
@export var mob_speed = 20.0
@export var mob_value = 100

@onready var anima: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: Area2D = $HitBox
@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector

var status: TotemState
var life = 2
var direction = -1

func _ready() -> void:
	start_move()

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	
	match status:
		TotemState.walk:
			walk_state(delta)
		TotemState.dead:
			dead_state(delta)
	
	move_and_slide()

func start_move():
	if initial_direction == -1:
		direction *= -1
		scale.x *= -1
	go_to_walk_state()

func walk_state(_delta):
	velocity.x = mob_speed * direction
	if wall_detector.is_colliding():
		scale.x *= -1
		direction *= -1
		
	if not ground_detector.is_colliding():
		scale.x *= -1
		direction *= -1

func dead_state(delta):
	apply_gravity(delta)
	set_collision_mask_value(1, false)
	await get_tree().create_timer(2.0).timeout
	queue_free()

func go_to_walk_state():
	status = TotemState.walk
	if life > 1:
		anima.play("walk")
	else:
		anima.play("walk_small")

func go_to_dead_state():
	if life > 1:
		life -= 1
		anima.position.y = 8
		anima.play("dead")
		await get_tree().create_timer(0.3).timeout
		go_to_walk_state()
	else:
		status = TotemState.dead
		anima.play("dead")
		hit_box.remove_from_group("enemy_hitbox")
		remove_from_group("enemy_body")
		Globals.player_score += mob_value
		velocity.y = -200

func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func take_damage():
	go_to_dead_state()

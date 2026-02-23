extends CharacterBody2D

enum CherryState{
	walk,
	dead
}

@export var mob_value = 150
@export var initial_direction = 1

@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector
@onready var anima: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: Area2D = $HitBox

const SPEED = 20

var status: CherryState
var direction = -1
var is_ground = false

func _ready() -> void:
	start_move()

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	
	match status:
		CherryState.walk:
			walk_state(delta)
		CherryState.dead:
			dead_state(delta)
	
	move_and_slide()

func start_move():
	if initial_direction == -1:
		direction *= -1
		scale.x *= -1
	go_to_walk_state()

func go_to_walk_state():
	status = CherryState.walk
	anima.play("walk")
	
func walk_state(_delta):
	velocity.x = SPEED * direction
	if wall_detector.is_colliding():
		scale.x *= -1
		direction *= -1
		
	if not ground_detector.is_colliding() and is_on_floor():
		scale.x *= -1
		direction *= -1

func go_to_dead_state():
	hit_box.remove_from_group("enemy_hitbox")
	remove_from_group("enemy_body")
	velocity.y = -200
	status = CherryState.dead
	anima.play("dead")
	Globals.player_score += mob_value

func dead_state(delta):
	apply_gravity(delta)
	set_collision_mask_value(1, false)
	await get_tree().create_timer(1.0).timeout
	queue_free()

func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func take_damage():
	go_to_dead_state()

extends CharacterBody2D

enum CherryState{
	patrol,
	dead
}

@export var mob_value = 150
@export var speed_of_patrol = 40
@export var arrive_distance = 5
@export var initial_direction = 1

@onready var anima: AnimatedSprite2D = $AnimatedSprite2D
@onready var patrol_points = $PatrolPoints.get_children()
@onready var hit_box: Area2D = $HitBox

var status: CherryState
var current_point = 0
var patrol_positions: Array[Vector2] = []

func _ready() -> void:
	#anima.flip_h = initial_direction == -1
	for p in patrol_points:
		patrol_positions.append(p.global_position)
	
	go_to_patrol_state()

func _physics_process(delta: float) -> void:
	
	match status:
		CherryState.patrol:
			patrol_state(delta)
		CherryState.dead:
			dead_state(delta)
	
	move_and_slide()

func go_to_patrol_state():
	status = CherryState.patrol
	anima.play("patrol")

func patrol_state(_delta):
	var target = patrol_positions[current_point]
	var direction = (target - global_position).normalized()

	velocity = direction * speed_of_patrol

	if abs(direction.x) > 0.01:
		anima.flip_h = direction.x > 0

	if global_position.distance_to(target) < arrive_distance:
		current_point = (current_point + 1) % patrol_positions.size()

func go_to_dead_state():
	hit_box.remove_from_group("enemy_hitbox")
	remove_from_group("enemy_body")
	velocity.y = -200
	anima.queue_free()
	Globals.player_score += mob_value
	status = CherryState.dead

func dead_state(_delta):
	queue_free()

func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func take_damage():
	go_to_dead_state()

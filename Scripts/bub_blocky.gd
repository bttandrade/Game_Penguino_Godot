extends CharacterBody2D

enum BlockyState{
	walk,
	block,
	dead
}

@export var initial_direction = 0
@export var mob_speed = 20.0
@export var mob_value = 100

@onready var anima: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: Area2D = $HitBox
@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector

var status: BlockyState
var direction = -1

func _ready() -> void:
	start_move()

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	
	match status:
		BlockyState.walk:
			walk_state(delta)
		BlockyState.block:
			block_state(delta)
		BlockyState.dead:
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
	hit_box.add_to_group("enemy_hitbox")
	add_to_group("enemy_body")
	set_collision_layer_value(1, false)
	status = BlockyState.walk
	anima.play("walk")
	await get_tree().create_timer(3.0).timeout
	go_to_block_state()

func go_to_dead_state():
	hit_box.remove_from_group("enemy_hitbox")
	remove_from_group("enemy_body")
	velocity.y = -200
	status = BlockyState.dead
	anima.play("dead")
	Globals.player_score += mob_value

func go_to_block_state():
	set_collision_layer_value(1, true)
	status = BlockyState.block
	anima.play("block")
	await get_tree().create_timer(3.0).timeout
	go_to_walk_state()

func block_state(_delta):
	hit_box.remove_from_group("enemy_hitbox")
	remove_from_group("enemy_body")
	velocity = Vector2.ZERO

func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func take_damage():
	go_to_dead_state()

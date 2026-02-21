extends CharacterBody2D

enum SkeletonState{
	walk,
	attack,
	dead
}

@export var initial_direction = 0
@export var mob_value = 100

@onready var anima: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: Area2D = $HitBox
@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector
@onready var player_detector: RayCast2D = $PlayerDetector
@onready var bone_start_position: Node2D = $BoneStartPosition

const SPINNING_BONE = preload("uid://b3pnlqs8ot0vo")
const SPEED = 20.0

var status: SkeletonState
var direction = 1
var can_throw = true

func _ready() -> void:
	start_move()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	match status:
		SkeletonState.walk:
			walk_state(delta)
		SkeletonState.dead:
			dead_state(delta)
		SkeletonState.attack:
			attack_state(delta)

	move_and_slide()

func start_move():
	if initial_direction == -1:
		direction *= -1
		scale.x *= -1
	go_to_walk_state()

func walk_state(_delta):
	if anima.frame == 2 or anima.frame == 3:
		velocity.x = SPEED * direction
	else:
		velocity.x = 0
	if wall_detector.is_colliding():
		scale.x *= -1
		direction *= -1
		
	if not ground_detector.is_colliding():
		scale.x *= -1
		direction *= -1
		
	if player_detector.is_colliding():
		go_to_attack_state()
		return
		
func dead_state(_delta):
	pass
	
func attack_state(_delta):
	if anima.frame == 2 and can_throw:
		throw_bone()
		can_throw = false
	
func go_to_walk_state():
	status = SkeletonState.walk
	anima.play("walk")

func go_to_dead_state():
	status = SkeletonState.dead
	anima.play("dead")
	Globals.player_score += mob_value
	hit_box.queue_free()
	remove_from_group("DamageArea")
	velocity = Vector2.ZERO
	
func go_to_attack_state():
	status = SkeletonState.attack
	anima.play("attack")
	velocity = Vector2.ZERO
	can_throw = true
	
func take_damage():
	go_to_dead_state()
	
func throw_bone():
	var new_bone = SPINNING_BONE.instantiate()
	add_sibling(new_bone)
	new_bone.position = bone_start_position.global_position
	new_bone.set_direction(self.direction)

func _on_animated_sprite_2d_animation_finished() -> void:
	if anima.animation == "attack":
		go_to_walk_state()
		return
	
	
	
	
	

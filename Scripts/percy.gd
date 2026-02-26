extends CharacterBody2D

enum PercyState{
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
@onready var fire_start_position: Node2D = $FireStartPosition

const FIREBALL = preload("res://Entities/fireball.tscn")
const SPEED = 20.0

var status: PercyState
var direction = 1
var can_spit = true
var life = 2

func _ready() -> void:
	start_move()

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	
	match status:
		PercyState.walk:
			walk_state(delta)
		PercyState.dead:
			dead_state(delta)
		PercyState.attack:
			attack_state(delta)
	
	move_and_slide()

func start_move():
	if initial_direction == -1:
		direction *= -1
		scale.x *= -1
	go_to_walk_state()

func walk_state(_delta):
	velocity.x = SPEED * direction
	
	if wall_detector.is_colliding():
		scale.x *= -1
		direction *= -1
		
	if not ground_detector.is_colliding():
		scale.x *= -1
		direction *= -1
		
	if player_detector.is_colliding():
		go_to_attack_state()
		return

func dead_state(delta):
	apply_gravity(delta)
	set_collision_mask_value(1, false)
	await get_tree().create_timer(2.0).timeout
	queue_free()

func attack_state(_delta):
	if anima.frame == 4 and can_spit:
		spit_fire()
		can_spit = false

func go_to_walk_state():
	status = PercyState.walk
	anima.play("walk")

func go_to_dead_state():
	if life > 1:
		life -= 1
		anima.play("dead")
		await get_tree().create_timer(0.3).timeout
		go_to_walk_state()
	else:
		status = PercyState.dead
		anima.play("dead")
		hit_box.remove_from_group("enemy_hitbox")
		remove_from_group("enemy_body")
		Globals.player_score += mob_value
		velocity.y = -200

func go_to_attack_state():
	status = PercyState.attack
	anima.play("attack")
	velocity = Vector2.ZERO
	can_spit = true

func take_damage():
	go_to_dead_state()

func spit_fire():
	var new_fire = FIREBALL.instantiate()
	add_sibling(new_fire)
	new_fire.position = fire_start_position.global_position
	new_fire.set_direction(self.direction)

func _on_animated_sprite_2d_animation_finished() -> void:
	if anima.animation == "attack":
		go_to_walk_state()
		return

func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

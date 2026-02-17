extends CharacterBody2D

enum PlayerState{
	idle,
	walk,
	jump,
	duck, 
	fall,
	slide,
	wall,
	swim,
	dead
} 

@onready var anima: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var reload_timer: Timer = $ReloadTimer
@onready var hit_box_collision_shape: CollisionShape2D = $HitBox/CollisionShape2D
@onready var left_wall_detector: RayCast2D = $LeftWallDetector
@onready var right_wall_detector: RayCast2D = $RightWallDetector

const JUMP_VELOCITY = -300.0

@export var max_speed = 100
@export var acceleration = 400
@export var deceleration = 400
@export var slide_deceleration = 100
@export var max_jump_count = 2
@export var wall_acceleration = 40
@export var wall_jump_velocity = 250
@export var water_max_speed = 100
@export var water_acceleration = 200
@export var water_jump_force = -100

var jump_count = 0
var direction = 0
var status: PlayerState

func _ready() -> void:
	go_to_idle_state()

func _physics_process(delta: float) -> void:
		
	match status:
		PlayerState.idle:
			idle_state(delta)
		PlayerState.walk:
			walk_state(delta)
		PlayerState.jump:
			jump_state(delta)
		PlayerState.duck:
			duck_state(delta)
		PlayerState.fall:
			fall_state(delta)
		PlayerState.slide:
			slide_state(delta)
		PlayerState.wall:
			wall_state(delta)
		PlayerState.swim:
			swim_state(delta)
		PlayerState.dead:
			dead_state(delta)
			
	move_and_slide()

func go_to_idle_state():
	status = PlayerState.idle
	anima.play("idle")

func go_to_walk_state():
	status = PlayerState.walk
	anima.play("walk")
	
func go_to_jump_state():
	status = PlayerState.jump
	anima.play("jump")
	velocity.y = JUMP_VELOCITY
	jump_count += 1
	
func go_to_fall_state():
	status = PlayerState.fall
	anima.play("fall")
	
func go_to_duck_state():
	status = PlayerState.duck
	anima.play("duck")
	set_collision(10, 3)
	
func exit_from_duck_state():
	set_collision(16, 0)
	
func go_to_slide_state():
	status = PlayerState.slide
	anima.play("slide")
	set_collision(10, 3)
	
func exit_slide_state():
	set_collision(16, 0)
	
func go_to_wall_state():
	status = PlayerState.wall
	anima.play("wall")
	velocity = Vector2.ZERO
	jump_count = 0
	
func go_to_swim_state():
	status = PlayerState.swim
	anima.play("swim")
	velocity.y = min(velocity.y, 150)
	
func go_to_dead_state():
	if status == PlayerState.dead:
		return
	status = PlayerState.dead
	anima.play("dead")
	velocity.x = 0
	reload_timer.start()

func idle_state(delta):
	apply_gravity(delta)
	move(delta)
	
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
	
	if Input.is_action_pressed("duck"):
		go_to_duck_state()
		return
		
	if velocity.x != 0:
		go_to_walk_state()
		return

func walk_state(delta):
	apply_gravity(delta)
	move(delta)
	if velocity.x == 0:
		go_to_idle_state()
		return
	
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
	
	if !is_on_floor():
		jump_count += 1
		go_to_fall_state()
		return
		
	if Input.is_action_just_pressed("duck"):
		go_to_slide_state()
		return
		
func jump_state(delta):
	apply_gravity(delta)
	move(delta)
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
		return
	
	if velocity.y > 0:
		go_to_fall_state()
		return
		
func fall_state(delta):
	apply_gravity(delta)
	move(delta)
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
		return
	
	if is_on_floor():
		jump_count = 0
		if velocity.x == 0:
			go_to_idle_state()
		else: 
			go_to_walk_state()
		return
	
	if (left_wall_detector.is_colliding() or right_wall_detector.is_colliding()) and is_on_wall():
		go_to_wall_state()
			
func duck_state(delta):
	apply_gravity(delta)
	update_direction()
	if Input.is_action_just_released("duck"):
		exit_from_duck_state()
		go_to_idle_state()
		return

func slide_state(delta):
	apply_gravity(delta)
	velocity.x = move_toward(velocity.x, 0, slide_deceleration * delta)
	if Input.is_action_just_released("duck"):
		exit_slide_state()
		go_to_walk_state()
		
	if velocity.x == 0:
		exit_slide_state()
		go_to_duck_state()
		
func wall_state(delta):
	velocity.y += wall_acceleration * delta
	
	if left_wall_detector.is_colliding():
		anima.flip_h = false
		direction = 1
	elif right_wall_detector.is_colliding():
		anima.flip_h = true
		direction = -1
	else:
		go_to_fall_state()
		return
		
	if is_on_floor():
		go_to_idle_state()
		return
		
	if Input.is_action_just_pressed("jump"):
		velocity.x = wall_jump_velocity * direction
		go_to_jump_state()
		return
		
func swim_state(delta):
	update_direction()
	
	if direction:
		velocity.x = move_toward(velocity.x, water_max_speed * direction, water_acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, water_acceleration * delta)
		
	#var vertical_direction = Input.get_axis("jump", "duck")
	#if vertical_direction:
	#	velocity.y = move_toward(velocity.y, water_max_speed * vertical_direction, water_acceleration * delta)
	#else:
	#	velocity.y = move_toward(velocity.y, 0, water_acceleration * delta)
	
	velocity.y += water_acceleration * delta
	velocity.y = min(velocity.y, water_max_speed)
	
	if Input.is_action_just_pressed("jump"):
		velocity.y = water_jump_force
	
func dead_state(_delta):
	pass
	
func move(delta):
	update_direction()
	if direction:
		velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)

func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func update_direction():
	direction = Input.get_axis("left", "right")
	
	if direction < 0:
		anima.flip_h = true
	elif direction > 0:
		anima.flip_h = false	
		
func can_jump() -> bool:
	return jump_count < max_jump_count
		
func set_collision(sizeY, positionY):
	collision_shape.shape.size.y = sizeY
	collision_shape.position.y = positionY
	hit_box_collision_shape.shape.size.y = sizeY
	hit_box_collision_shape.position.y = positionY

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemies"):
		hit_enemy(area)
	elif area.is_in_group("DamageArea"):
		hit_damage_area()

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("DamageArea"):
		go_to_dead_state()
	elif body.is_in_group("Water"):
		go_to_swim_state()

func _on_hit_box_body_exited(body: Node2D) -> void:
	if body.is_in_group("Water"):
		jump_count = 0
		go_to_jump_state()

func _on_reload_timer_timeout() -> void:
	get_tree().reload_current_scene()

func hit_enemy(area: Area2D):
	if velocity.y > 0:
		area.get_parent().take_damage()
		go_to_jump_state()
	else:
		go_to_dead_state()
	
func hit_damage_area():
	go_to_dead_state()

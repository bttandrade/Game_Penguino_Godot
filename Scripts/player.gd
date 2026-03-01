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
	hurt,
	dead
} 

@export var max_speed: float = 100.0
@export var acceleration: float = 400.0
@export var deceleration: float = 400.0
@export var slide_deceleration: float = 100.0
@export var max_jump_count: int = 2
@export var wall_acceleration: float = 40.0
@export var wall_jump_velocity: float = 250.0
@export var water_max_speed: float = 100.0
@export var water_acceleration: float = 200.0
@export var water_jump_force: float = -100.0
@export var knockback_value: float = 200.0

@onready var player_scene = preload("res://Entities/player.tscn")
@onready var anima: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var left_wall_detector: RayCast2D = $LeftWallDetector
@onready var right_wall_detector: RayCast2D = $RightWallDetector
@onready var hurt_box: Area2D = $HitBoxes/HurtBox
@onready var hurt_box_collision: CollisionShape2D = $HitBoxes/HurtBox/CollisionShape2D
@onready var stomp_box: Area2D = $HitBoxes/StompBox
@onready var stomp_box_collision: CollisionShape2D = $HitBoxes/StompBox/CollisionShape2D
@onready var jump_sound: AudioStreamPlayer = $Sounds/JumpSound
@onready var hit_sound: AudioStreamPlayer = $Sounds/HitSound
@onready var hurt_sound: AudioStreamPlayer = $Sounds/HurtSound
@onready var coin_spawn_sound: AudioStreamPlayer = $Sounds/CoinSpawnSound
@onready var swimming_sound: AudioStreamPlayer = $Sounds/SwimmingSound
@onready var water_splash_sound: AudioStreamPlayer = $Sounds/WaterSplashSound

const JUMP_VELOCITY = -300.0
const RIGID_COIN = preload("res://Entities/rigid_coin.tscn")

var last_direction = 0
var jump_count = 0
var direction = 0
var control_lock = false
var status: PlayerState

func _ready() -> void:
	if get_parent().has_node("HUD"):
		var hud_manager: Control = $"../HUD/HUDManager"
		hud_manager.time_is_up.connect(go_to_dead_state)	
	Globals.current_checkpoint = self.global_position
	go_to_idle_state()

func _physics_process(delta: float) -> void:
	if control_lock:
		velocity.x = 0
		apply_gravity(delta)
		move_and_slide()
		return
		
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
		PlayerState.hurt:
			hurt_state(delta)
		PlayerState.dead:
			dead_state(delta)

	move_and_slide()

func go_to_idle_state():
	status = PlayerState.idle
	anima.play("idle")

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

func go_to_walk_state():
	status = PlayerState.walk
	anima.play("walk")

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

func go_to_jump_state():
	status = PlayerState.jump
	jump_sound.play()
	anima.play("jump")
	velocity.y = JUMP_VELOCITY
	jump_count += 1

func jump_state(delta):
	apply_gravity(delta)
	move(delta)
	
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
		return
	
	if velocity.y > 0:
		go_to_fall_state()
		return

func go_to_fall_state():
	status = PlayerState.fall
	anima.play("fall")

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

func go_to_duck_state():
	status = PlayerState.duck
	anima.play("duck")
	set_collision_duck()

func duck_state(delta):
	apply_gravity(delta)
	update_direction()
	
	if Input.is_action_just_released("duck"):
		set_collision_back()
		go_to_idle_state()
		return

func go_to_slide_state():
	status = PlayerState.slide
	anima.play("slide")
	set_collision_duck()

func slide_state(delta):
	apply_gravity(delta)
	velocity.x = move_toward(velocity.x, 0, slide_deceleration * delta)
	if Input.is_action_just_released("duck"):
		set_collision_back()
		go_to_walk_state()
		
	if velocity.x == 0:
		set_collision_back()
		go_to_duck_state()

func go_to_wall_state():
	status = PlayerState.wall
	anima.play("wall")
	velocity = Vector2.ZERO
	jump_count = 1

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

func go_to_swim_state():
	status = PlayerState.swim
	water_splash_sound.play()
	anima.play("swim")
	velocity.y = min(velocity.y, 150)

func swim_state(delta):
	update_direction()
	
	if direction:
		velocity.x = move_toward(velocity.x, water_max_speed * direction, water_acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, water_acceleration * delta)
	
	velocity.y += water_acceleration * delta
	velocity.y = min(velocity.y, water_max_speed)
	
	if Input.is_action_just_pressed("jump"):
		swimming_sound.play()
		velocity.y = water_jump_force

func go_to_hurt_state():
	status = PlayerState.hurt
	anima.modulate = Color(1, 0, 0, 1)
	var knockback_tween = get_tree().create_tween()
	knockback_tween.tween_property(anima, "modulate", Color(1, 1, 1, 1), 0.25)
	velocity.y = JUMP_VELOCITY
	hurt_sound.play()
	anima.play("dead")
	jump_count = 0
	respawn()

func hurt_state(delta):
	apply_gravity(delta)

func go_to_dead_state():
	if status == PlayerState.dead:
		return
	status = PlayerState.dead
	Globals.player_life = 0
	control_lock = true
	velocity = Vector2.ZERO
	anima.play("dead")
	hurt_sound.play()
	respawn()

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
	if control_lock:
		direction = 0
		return
		
	direction = Input.get_axis("left", "right")
	
	if direction < 0:
		anima.flip_h = true
	elif direction > 0:
		anima.flip_h = false

func can_jump() -> bool:
	return jump_count < max_jump_count

func set_collision_duck():
	collision_shape.shape.radius = 5
	collision_shape.shape.height = 12
	collision_shape.position.y = 3
	collision_shape.rotation_degrees = 90
	
	hurt_box_collision.shape.size = Vector2(12, 8)
	hurt_box_collision.position.y = 2

func set_collision_back():
	collision_shape.shape.radius = 6
	collision_shape.shape.height = 14
	collision_shape.position.y = 1
	collision_shape.rotation_degrees = 0
	
	hurt_box_collision.shape.size = Vector2(12, 12)
	hurt_box_collision.position.y = 0

func respawn():
	await get_tree().create_timer(1.0).timeout
	control_lock = false
	set_collision_back()
	Globals.player = $"."
	Globals.respawn_player()
	go_to_idle_state()

func hit_enemy(area: Area2D):
	if velocity.y > 0 and area.is_in_group("enemy_body"):
		area.get_parent().take_damage()
		go_to_jump_state()

func took_a_hit(area):
	if Globals.player_life <= 0:
		return
	control_lock = true
	var enemy_pos_x = area.global_position.x
	var player_pos_x = global_position.x
	var direction_of_hit = 0
	
	if enemy_pos_x > player_pos_x:
		direction_of_hit = -1
	else:
		direction_of_hit = 1
	
	velocity.x = knockback_value * direction_of_hit
	lose_coins()
	be_invincible()
	go_to_hurt_state()

func be_invincible():
	hurt_box.set_collision_mask_value(6, false)
	stomp_box.set_collision_mask_value(5, false)
	stomp_box.set_collision_mask_value(7, false)
	await get_tree().create_timer(1.0).timeout
	hurt_box.set_collision_mask_value(6, true)
	stomp_box.set_collision_mask_value(5, true)
	stomp_box.set_collision_mask_value(7, true)

func lose_coins():
	var lost_coins = min(Globals.player_coins, 5)
	Globals.player_coins -= lost_coins
	for i in lost_coins:
		set_collision_layer_value(2, false)
		var coin = RIGID_COIN.instantiate()
		get_parent().call_deferred("add_child", coin)
		coin.global_position = global_position
		coin.apply_impulse(Vector2(randi_range(-100, 100), -250))
		await  get_tree().create_timer(0.03).timeout
		coin_spawn_sound.play()
	await  get_tree().create_timer(1.5).timeout
	set_collision_layer_value(2, true)

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hitbox"):
		took_a_hit(area)

func _on_stomp_box_body_entered(body: Node2D) -> void:
	if control_lock or status == PlayerState.hurt:
		return
		
	if body.is_in_group("water_body"):
		go_to_swim_state()
		return
		
	if body.is_in_group("lethal_body"):
		control_lock = true
		be_invincible()
		go_to_hurt_state()
		return
		
	if velocity.y > 0 and body.is_in_group("enemy_body"):
		body.take_damage()
		hit_sound.play()
		go_to_jump_state()

func _on_stomp_box_body_exited(body: Node2D) -> void:
	if control_lock or status == PlayerState.hurt:
		return
		
	if body.is_in_group("water_body"):
		water_splash_sound.play()
		jump_count = 1
		go_to_jump_state()

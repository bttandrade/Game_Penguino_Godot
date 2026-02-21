extends CharacterBody2D

enum CherryState{
	patrol,
	dead
}
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var status: CherryState

@export var mob_value = 100

@onready var anima: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: Area2D = $HitBox

func _ready() -> void:
	go_to_patrol_state()

func _physics_process(delta: float) -> void:
	apply_gravity(delta)

	match status:
		CherryState.patrol:
			patrol_state(delta)
		CherryState.dead:
			dead_state(delta)

	move_and_slide()

func dead_state(delta):
	apply_gravity(delta)
	set_collision_mask_value(1, false)
	await get_tree().create_timer(1.0).timeout
	queue_free()
	
func go_to_patrol_state():
	anima.play("patrol")
	
func patrol_state(delta):
	pass

func go_to_dead_state():
	velocity.y = -200
	status = CherryState.dead
	anima.play("dead")
	Globals.player_score += mob_value
	hit_box.process_mode = Node.PROCESS_MODE_DISABLED
	remove_from_group("DamageArea")

func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func take_damage():
	go_to_dead_state()

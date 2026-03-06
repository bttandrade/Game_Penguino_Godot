extends Camera2D

var target: Node2D

func _ready() -> void:
	get_target()

var current_offset = 0.0
var duck_offset = 60.0

func _physics_process(delta):
	if target == null:
		return
	
	var desired_offset = 0.0
	
	if target.status == target.PlayerState.duck:
		desired_offset = duck_offset
	
	current_offset = lerp(current_offset, desired_offset, 5 * delta)
	
	position = target.position + Vector2(0, current_offset)

func get_target():
	var nodes = get_tree().get_nodes_in_group("player_body")
	if nodes.size() == 0:
		push_error("Player not found")
		return
		
	target = nodes[0]

extends CanvasLayer

@onready var scroll: ScrollContainer = $DialogBox/ScrollContainer

@export var base_speed = 120.0
@export var max_speed = 600.0
@export var acceleration = 1200.0
@export var deceleration = 1600.0

var current_speed = 0.0
var direction = 0.0

func _process(delta):
	update_input()
	update_scroll(delta)

func update_input():
	direction = 0
	
	if Input.is_action_pressed("ui_down"):
		direction += 1
	if Input.is_action_pressed("ui_up"):
		direction -= 1

func update_scroll(delta):
	if direction != 0:
		current_speed += acceleration * delta
		current_speed = clamp(current_speed, base_speed, max_speed)
	else:
		current_speed -= deceleration * delta
		current_speed = max(current_speed, 0)
	
	if current_speed > 0:
		scroll.scroll_vertical += direction * current_speed * delta
	
	clamp_scroll()

func clamp_scroll():
	var max_scroll = scroll.get_v_scroll_bar().max_value
	scroll.scroll_vertical = clamp(scroll.scroll_vertical, 0, max_scroll)

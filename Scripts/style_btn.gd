extends Button

var normal_shadow_size := 1
var pressed_shadow_size := 1

var normal_offset := Vector2(0, 4)
var pressed_offset := Vector2(0, 1)

var style: StyleBoxFlat

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var original := get_theme_stylebox("normal") as StyleBoxFlat
	style = original.duplicate(true)
	add_theme_stylebox_override("normal", style)
	add_theme_stylebox_override("pressed", style)

	button_down.connect(_press)
	button_up.connect(_release)

func _press():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(style, "shadow_size", pressed_shadow_size, 1)
	tween.tween_property(style, "shadow_offset", pressed_offset, 0.08)
	tween.tween_property(self, "position:y", position.y + 3, 0.08)

func _release():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(style, "shadow_size", normal_shadow_size, 0.08)
	tween.tween_property(style, "shadow_offset", normal_offset, 0.08)
	tween.tween_property(self, "position:y", position.y - 3, 0.08)

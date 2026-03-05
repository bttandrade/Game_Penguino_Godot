extends AnimatableBody2D

@export var time = 1

@onready var target: Sprite2D = $Target

func _ready() -> void:
	target.visible = false
	
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "global_position", target.global_position, time)
	tween.tween_property(self, "global_position", global_position, time)
	tween.set_loops()

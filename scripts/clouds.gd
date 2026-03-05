extends Parallax2D

@export var cloud_speed: float = 20.0
@onready var sprite_2d: Sprite2D = $Sprite2D

func _process(delta):
	sprite_2d.position.x -= cloud_speed * delta

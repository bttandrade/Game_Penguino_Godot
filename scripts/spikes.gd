extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	collision.shape.size.x = sprite.get_rect().size.x

func _process(_delta: float) -> void:
	pass

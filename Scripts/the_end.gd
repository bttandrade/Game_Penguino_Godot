extends Node2D

@onready var penguino: CharacterBody2D = $Penguinos/Penguino
@onready var penguino_2: CharacterBody2D = $Penguinos/Penguino2
@onready var penguino_3: CharacterBody2D = $Penguinos/Penguino3
@onready var penguino_4: CharacterBody2D = $Penguinos/Penguino4
@onready var stop: Area2D = $Stop
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	penguino_3.get_node("AnimatedSprite2D").play("idle")

func _process(_delta: float) -> void:
	pass

func _on_stop_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_body"):
		player.anima.play("turn")
		player.control_lock = true

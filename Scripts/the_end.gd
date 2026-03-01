extends Node2D

@onready var penguino_3: CharacterBody2D = $Penguinos/Penguino3
@onready var stop: Area2D = $Stop
@onready var player: CharacterBody2D = $Player
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	penguino_3.get_node("AnimatedSprite2D").play("idle")

func _on_stop_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_body"):
		player.anima.play("turn")
		player.control_lock = true

func _on_audio_stream_player_finished() -> void:
	audio.play()

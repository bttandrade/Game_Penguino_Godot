extends Node2D

@onready var penguino_3: CharacterBody2D = $Mobs/Penguino3
@onready var player: CharacterBody2D = $Player
@onready var stop: Area2D = $StageStuff/Stop
@onready var audio: AudioStreamPlayer = $HUDs/AudioStreamPlayer
@onready var canvas_end: CanvasLayer = $HUDs/CanvasEnd

func _ready() -> void:
	penguino_3.get_node("AnimatedSprite2D").play("idle")
	DialogManager.game_has_ended.connect(the_end)

func _on_stop_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_body"):
		player.anima.play("turn")
		player.control_lock = true

func _on_audio_stream_player_finished() -> void:
	audio.play()

func the_end():
	pass

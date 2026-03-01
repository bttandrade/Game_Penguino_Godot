extends Area2D

@export var next_level = ""

@onready var player: CharacterBody2D = get_parent().get_node("Player")
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var stage_name = get_parent().name

var stage_song = ""

func _ready() -> void:
	match stage_name:
		"Spring1":
			audio.stream = load("res://Sounds/spring_1.wav")
		"Spring2":
			audio.stream = load("res://Sounds/spring_2.wav")
		"Spring3":
			audio.stream = load("res://Sounds/spring_3.wav")
		"Spring4":
			audio.stream = load("res://Sounds/spring_4.wav")
		"Summer1":
			audio.stream = load("res://Sounds/summer_1.wav")
		"Summer2":
			audio.stream = load("res://Sounds/summer_2.wav")
		"Summer3":
			audio.stream = load("res://Sounds/summer_3.wav")
		"Summer4":
			audio.stream = load("res://Sounds/summer_4.wav")
		"Autumn1":
			audio.stream = load("res://Sounds/autumn_1.wav")
		"Autumn2":
			audio.stream = load("res://Sounds/autumn_2.wav")
		"Autumn3":
			audio.stream = load("res://Sounds/autumn_3.wav")
		"Autumn4":
			audio.stream = load("res://Sounds/autumn_4.wav")
		"Winter1":
			audio.stream = load("res://Sounds/winter_1.wav")
		"Winter2":
			audio.stream = load("res://Sounds/winter_2.wav")
		"Winter3":
			audio.stream = load("res://Sounds/winter_3.wav")
		"Winter4":
			audio.stream = load("res://Sounds/winter_4.wav")
	audio.play()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_body"):
		audio.stream = load("res://Sounds/stage_end.wav")
		audio.play()
		player.anima.play("dancing")
		player.control_lock = true
		await get_tree().create_timer(2.5).timeout
		load_next_scene()

func load_next_scene():
	get_tree().change_scene_to_file("res://scenes/" + next_level + ".tscn")

func _on_audio_stream_player_finished() -> void:
	audio.play()

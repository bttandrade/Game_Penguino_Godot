extends Control

@onready var restart_btn: Button = $MarginContainer/MenuHolder/RestartBtn
@onready var game_over_title: TextureRect = $GameOverTitle
@onready var audio: AudioStreamPlayer = $GameOverSound

const GAME_OVER = preload("res://Assets/Universal/game_over.png")
const THE_END = preload("res://Assets/Universal/the_end.png")

var on_menu = false

func _ready() -> void:
	on_menu = true
	if Globals.finished_the_game:
		audio.stream = load("res://Sounds/final.wav")
		audio.play()
		game_over_title.texture = THE_END
	else:
		audio.stream = load("res://Sounds/game_over.wav")
		audio.play()
		game_over_title.texture = GAME_OVER

func _process(_delta: float) -> void:
	if on_menu:
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
			restart_btn.grab_focus()
			on_menu = false

func _on_restart_btn_pressed() -> void:
	Globals.restart()
	get_tree().change_scene_to_file("res://Scenes/spring_1.tscn")

func _on_quit_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")

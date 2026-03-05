extends CanvasLayer

@onready var restart_btn: Button = $MarginContainer/MenuHolder/RestartBtn
@onready var game_over_title: TextureRect = $GameOverTitle
@onready var audio: AudioStreamPlayer = $GameOverSound

const GAME_OVER = preload("res://assets/universal/game_over.png")
const THE_END = preload("res://assets/universal/the_end.png")

var on_menu = true
var has_played_song = false

func _ready() -> void:
	visible = false

func _process(_delta: float) -> void:
	if visible:
		if Globals.finished_the_game:
			game_over_title.texture = THE_END
		else:
			play_song()
			has_played_song = true
			game_over_title.texture = GAME_OVER
		get_tree().paused = true
		if on_menu:
			if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
				restart_btn.grab_focus()
				on_menu = false

func play_song():
	if !has_played_song:
		audio.stream = load("res://sounds/game_over.wav")
		audio.play()

func _on_restart_btn_pressed() -> void:
	visible = false
	get_tree().paused = false
	Globals.restart()
	get_tree().change_scene_to_file("res://scenes/spring_1.tscn")

func _on_quit_btn_pressed() -> void:
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

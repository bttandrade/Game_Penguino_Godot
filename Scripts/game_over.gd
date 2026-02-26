extends Control

@onready var restart_btn: Button = $MarginContainer/MenuHolder/RestartBtn

var on_menu = false

func _ready() -> void:
	on_menu = true

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

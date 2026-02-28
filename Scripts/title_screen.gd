extends Control

@onready var start_btn: Button = $MarginContainer/VBoxContainer/StartBtn
@onready var continue_btn: Button = $MarginContainer/VBoxContainer/TutorialBtn
@onready var quit_btn: Button = $MarginContainer/VBoxContainer/QuitBtn
@onready var credits_btn: Button = $MarginContainer/VBoxContainer/CreditsBtn
@onready var tutorial: CanvasLayer = $Tutorial

var on_menu: bool = false

func _on_start_btn_pressed() -> void:
	on_menu = false
	tutorial.visible = false
	Globals.restart()
	get_tree().change_scene_to_file("res://Scenes/spring_1.tscn")

func _ready() -> void:
	on_menu = true

func _process(_delta: float) -> void:
	if on_menu:
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
			start_btn.grab_focus()
			on_menu = false

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _on_tutorial_btn_pressed() -> void:
	get_tree().paused = true
	tutorial.visible = true
	await get_tree().create_timer(3.0).timeout
	get_tree().paused = false
	tutorial.visible = false

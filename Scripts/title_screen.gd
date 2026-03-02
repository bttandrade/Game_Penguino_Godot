extends Control

@onready var start_btn: Button = $MarginContainer/VBoxContainer/StartBtn
@onready var continue_btn: Button = $MarginContainer/VBoxContainer/TutorialBtn
@onready var quit_btn: Button = $MarginContainer/VBoxContainer/QuitBtn
@onready var credits_btn: Button = $MarginContainer/VBoxContainer/CreditsBtn
@onready var tutorial: CanvasLayer = $Tutorial
@onready var credits: CanvasLayer = $Credits
@onready var title_sound: AudioStreamPlayer = $TitleSound

var on_menu: bool = false
var modal_open = false

func _on_start_btn_pressed() -> void:
	on_menu = false
	Globals.restart()
	get_tree().change_scene_to_file("res://Scenes/spring_1.tscn")

func _ready() -> void:
	on_menu = true
	tutorial.visible = false
	credits.visible = false

func _process(_delta: float) -> void:
	if modal_open:
		return
	
	if on_menu:
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
			start_btn.grab_focus()
			on_menu = false

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _on_tutorial_btn_pressed() -> void:
	get_viewport().gui_release_focus()
	modal_open = true
	tutorial.visible = true

func _on_credits_btn_pressed() -> void:
	get_viewport().gui_release_focus()
	modal_open = true
	credits.visible = true

func _unhandled_input(_event: InputEvent) -> void:
	if modal_open and Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("ui_accept"):
		credits.visible = false
		tutorial.visible = false
		on_menu = true
		modal_open = false

func _on_title_sound_finished() -> void:
	title_sound.play()

extends Control

@onready var start_btn: Button = $MarginContainer/VBoxContainer/StartBtn
@onready var continue_btn: Button = $MarginContainer/VBoxContainer/ContinueBtn
@onready var quit_btn: Button = $MarginContainer/VBoxContainer/QuitBtn
@onready var credits_btn: Button = $MarginContainer/VBoxContainer/CreditsBtn

var on_menu: bool = false

func _on_start_btn_pressed() -> void:
	on_menu = false
	get_tree().change_scene_to_file("res://Scenes/spring_1.tscn")

func _ready() -> void:
	on_menu = true

func _process(_delta: float) -> void:
	if on_menu:
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
			start_btn.grab_focus()
			on_menu = false

func _on_continue_btn_pressed() -> void:
	pass

func _on_creditsbtn_pressed() -> void:
	pass

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

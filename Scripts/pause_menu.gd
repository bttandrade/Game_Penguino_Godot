extends CanvasLayer

@onready var resume_btn: Button = $MarginContainer/MenuHolder/ResumeBtn

var on_menu: bool = false

func _ready() -> void:
	visible = false

func _process(_delta: float) -> void:
	if on_menu:
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
			resume_btn.grab_focus()
			on_menu = false

func _on_resume_btn_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_quit_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and Globals.can_pause:
		visible = true
		get_tree().paused = true
		on_menu = true

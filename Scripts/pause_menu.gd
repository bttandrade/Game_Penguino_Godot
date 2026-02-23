extends CanvasLayer

@onready var btn_resume: Button = $MenuHolder/BtnResume

func _ready() -> void:
	visible = false

func _on_btn_resume_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_btn_quit_pressed() -> void:
	get_tree().quit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		visible = true
		get_tree().paused = true
		btn_resume.grab_focus()

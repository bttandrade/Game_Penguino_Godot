extends CanvasLayer

@onready var season_logo: TextureRect = $MarginContainer/VBoxContainer/SeasonLogo
@onready var season_label: Label = $MarginContainer/VBoxContainer/Season
@onready var stage_label: Label = $MarginContainer/VBoxContainer/StageNumber
@onready var color_rect: ColorRect = $ColorRect

@export var which_season:String = ""
@export var stage_number:String = "1 - 1"

const SPRITE_0001 = preload("uid://631mogmas4lv")
const SPRITE_0002 = preload("uid://dh4nlyh1trlxl")
const SPRITE_0003 = preload("uid://d3i18imhxergh")
const SPRITE_0004 = preload("uid://ba4evrp1x57xg")

func _ready() -> void:
	season_label.text = which_season
	stage_label.text = stage_number
	match which_season:
		"PRIMAVERA":
			season_logo.texture = SPRITE_0001
		"VERÃO":
			season_logo.texture = SPRITE_0002
		"OUTONO":
			season_logo.texture = SPRITE_0003
		"INVERNO":
			season_logo.texture = SPRITE_0004
	color_rect.color = Color(0, 0, 0, 1)

	await get_tree().create_timer(0.5).timeout

	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 0.0, 1.0)

	await tween.finished
	queue_free()

extends CanvasLayer

@onready var season_logo: TextureRect = $MarginContainer/VBoxContainer/SeasonLogo
@onready var season_label: Label = $MarginContainer/VBoxContainer/Season
@onready var stage_label: Label = $MarginContainer/VBoxContainer/StageNumber
@onready var color_rect: ColorRect = $ColorRect

@export var which_season:String = ""
@export var stage_number:String = "1 - 1"

const SPRITE_0001 = preload("res://Assets/Tilesets/TilesSpring/spring_logo.png")
const SPRITE_0002 = preload("res://Assets/Tilesets/TilesSummer/summer_logo.png")
const SPRITE_0003 = preload("res://Assets/Tilesets/TilesAutumn/autumn_logo.png")
const SPRITE_0004 = preload("res://Assets/Tilesets/TilesWinter/winter_logo.png")

func _ready() -> void:
	Globals.can_pause = false
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
	Globals.can_pause = true
	queue_free()

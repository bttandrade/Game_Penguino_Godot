extends Control

@export_range(0, 5) var default_minutes = 1
@export_range(0, 59) var default_seconds = 0

@onready var coin_amount: Label = $MarginContainer/CoinContainer/CoinAmount
@onready var time_amount: Label = $MarginContainer/TimeContainer/MarginContainer2/TimeAmount
@onready var score_amount: Label = $MarginContainer/ScoreContainer/MarginContainer2/ScoreAmount
@onready var life_amount: Label = $MarginContainer/LifeContainer/LifeAmount
@onready var clock_timer: Timer = $ClockTimer

var minutes = 0
var seconds = 0

signal time_is_up()

func _ready() -> void:
	coin_amount.text = str("%04d" % Globals.player_coins)
	score_amount.text = str("%06d" % Globals.player_score)
	life_amount.text = str("%02d" % Globals.player_life)
	time_amount.text = str("%02d" % default_minutes) + ":" + str("%02d" % default_seconds)
	reset_clock_timer()

func _process(_delta: float) -> void:
	coin_amount.text = str("%04d" % Globals.player_coins)
	score_amount.text = str("%06d" % Globals.player_score)
	life_amount.text = str("%02d" % Globals.player_life)
	if minutes == 0 and seconds == 0:
		emit_signal("time_is_up")

func _on_clock_timer_timeout() -> void:
	if seconds == 0:
		if minutes > 0:
			minutes -= 1
			seconds = 60
	seconds -= 1
	
	time_amount.text = str("%02d" % minutes) + ":" + str("%02d" % seconds)

func reset_clock_timer():
	minutes = default_minutes
	seconds = default_seconds

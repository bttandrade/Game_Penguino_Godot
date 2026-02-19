extends Area2D

@onready var anima: AnimatedSprite2D = $AnimatedSprite2D
@onready var spawn_coins: Marker2D = $spawn_coins

@export var coin_amount = 5

var is_open = false
var coin_instance = preload("res://entities/rigid_coin.tscn")

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and is_open == false:
		anima.play("open")
		is_open = true
		for i in range(coin_amount):
			if i == 0:
				await get_tree().create_timer(0.4).timeout
			await get_tree().create_timer(0.2).timeout
			create_coins()

func create_coins():
	var coin = coin_instance.instantiate()
	get_parent().call_deferred("add_child", coin)
	coin.global_position = spawn_coins.global_position
	coin.apply_impulse(Vector2(randi_range(-50, 50), -150))

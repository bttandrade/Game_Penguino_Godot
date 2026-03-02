extends Node2D

@onready var penguino: CharacterBody2D = $Penguinos/Penguino
@onready var penguino_2: CharacterBody2D = $Penguinos/Penguino2
@onready var penguino_3: CharacterBody2D = $Penguinos/Penguino3
@onready var penguino_4: CharacterBody2D = $Penguinos/Penguino4
@onready var penguino_5: CharacterBody2D = $Penguinos/Penguino5
@onready var penguino_6: CharacterBody2D = $Penguinos/Penguino6
@onready var penguino_7: CharacterBody2D = $Penguinos/Penguino7
@onready var penguino_8: CharacterBody2D = $Penguinos/Penguino8
@onready var penguino_9: CharacterBody2D = $Penguinos/Penguino9
@onready var penguino_10: CharacterBody2D = $Penguinos/Penguino10
@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	penguino_2.get_node("AnimatedSprite2D").play("siting")
	penguino_5.get_node("AnimatedSprite2D").play("back")
	penguino.get_node("AnimatedSprite2D").play("idle")
	penguino_3.get_node("AnimatedSprite2D").play("idle")
	penguino_4.get_node("AnimatedSprite2D").play("idle")
	penguino_6.get_node("AnimatedSprite2D").play("idle")
	penguino_7.get_node("AnimatedSprite2D").play("idle")
	penguino_8.get_node("AnimatedSprite2D").play("idle")
	penguino_9.get_node("AnimatedSprite2D").play("siting")
	penguino_10.get_node("AnimatedSprite2D").play("idle")

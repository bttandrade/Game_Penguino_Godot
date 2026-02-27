extends Node2D

@export var lines: Array[String] = []

@onready var sprite: Sprite2D = $Sprite2D
@onready var sign_area: Area2D = $SignArea
@onready var spawn_other_place: Marker2D = $SpawnText

var player_inside = false
var success_line: String = ""
var success_line2: String = ""
var success_line3: String = ""
var success_line4: String = ""
var where_to_start = global_position

func _unhandled_input(event: InputEvent) -> void:
	if player_inside:
		if event.is_action_pressed("interact") and !DialogManager.is_message_active:
			if get_parent().name == "TheEnd":
				Globals.finished_the_game = true
				success_rate()
				lines = [
				"Bem-vindo de volta Penguino!",
				"Sei que teve uma aventura e tanto.",
				"Viajar por todas as estações, enfrentando seus perigos . . .",
				"Em busca de moedas para comprarmos comida.",
				success_line, success_line2, success_line3, success_line4]
				where_to_start = spawn_other_place.global_position
			DialogManager.start_message(where_to_start, lines)
	else:
		sprite.hide()
		if DialogManager.dialog_box != null:
			DialogManager.dialog_box.queue_free()
			DialogManager.is_message_active = false

func _on_sign_area_body_entered(_body: Node2D) -> void:
	player_inside = true
	sprite.show()

func _on_sign_area_body_exited(_body: Node2D) -> void:
	player_inside = false
	sprite.hide()

func success_rate():
	if Globals.player_coins <= 0:
		success_line = "Hmmm . . ."
		success_line2 = "Parece que não conseguiu nenhuma moeda dessa vez."
		success_line3 = "Mas pelo menos retornou em segurança, ficamos felizes."
		success_line4 = "Não se preocupe, iremos enviar outro Penguino na próxima estação."
	elif Globals.player_coins >= 1 and Globals.player_coins <= 20:
		success_line = "Hmmm . . ."
		success_line2 = "Parece que conseguiu algumas moedas dessa vez."
		success_line3 = "Que bom, com elas vamos aguentar mais uma estação!"
		success_line4 = "Não se preocupe, na próxima iremos enviar outro Penguino, venha e descanse!"
	elif Globals.player_coins >= 21 and Globals.player_coins <= 99:
		success_line = "Hmmm . . ."
		success_line2 = "Parece que conseguiu bastante moedas dessa vez!"
		success_line3 = "Que ótimo! Agora não precisaremos enviar outro Penguino por duas ou três estações!"
		success_line4 = "Venha e descanse Penguino, vamos comemorar!"
	elif Globals.player_coins >= 100:
		success_line = "Uaaauu!!"
		success_line2 = "Parece que conseguiu um MONTE de moedas dessa vez!"
		success_line3 = "Você é um héroi!! Agora não precisaremos enviar outro Penguino por várias estações!"
		success_line4 = "Venha e descanse Penguino, vamos comemorar como nunca antes!"

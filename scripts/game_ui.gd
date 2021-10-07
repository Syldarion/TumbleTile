extends Node

onready var blue_turn_indicator = $ScorePanel/ScoreContainer/BlueScoreContainer/TurnIndicator
onready var red_turn_indicator = $ScorePanel/ScoreContainer/RedScoreContainer/TurnIndicator
onready var blue_chits_container = $ScorePanel/ScoreContainer/BlueScoreContainer/ChitsContainer
onready var red_chits_container = $ScorePanel/ScoreContainer/RedScoreContainer/ChitsContainer
onready var blue_wins_label = $ScorePanel/ScoreContainer/BlueScoreContainer/ColorRect/WinsLabel
onready var red_wins_label = $ScorePanel/ScoreContainer/RedScoreContainer/ColorRect/WinsLabel


func _ready():
	pass

func switch_turn_indicator(player):
	if player == GameVariables.PLAYER_ONE:
		blue_turn_indicator.modulate.a = 255
		red_turn_indicator.modulate.a = 0
	else:
		blue_turn_indicator.modulate.a = 0
		red_turn_indicator.modulate.a = 255

func update_wins(player, wins):
	if player == GameVariables.PLAYER_ONE:
		blue_wins_label.text = str(wins)
	else:
		red_wins_label.text = str(wins)

func update_chip_count(player, chips):
	if player == GameVariables.PLAYER_ONE:
		for i in range(blue_chits_container.get_child_count() - 1, chips - 1, -1):
			blue_chits_container.get_child(i).hide()
	else:
		for i in range(red_chits_container.get_child_count() - 1, chips - 1, -1):
			red_chits_container.get_child(i).hide()

func reset_chip_indicators():
	for chip in blue_chits_container.get_children():
		chip.show()
	for chip in red_chits_container.get_children():
		chip.show()

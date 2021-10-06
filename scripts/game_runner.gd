class_name GameRunner
extends Node

export(Vector2) var player_one_indicator_pos
export(Vector2) var player_two_indicator_pos

onready var hex_map = $HexMap
onready var current_player_rect = $GameUI/CurrentRect
onready var player_one_chips_label = $GameUI/HBoxContainer/BluePlayerRect/BluePlayerChipCount
onready var player_two_chips_label = $GameUI/HBoxContainer/RedPlayerRect/RedPlayerChipCount

var chips_in_hand
var player_one_chips
var player_two_chips
var player_one_moves
var player_two_moves

func _ready():
	hex_map.connect("move_made", self, "_on_HexMap_move_made")
	start_new_game()

func start_new_game():
	reset_board()
	flip_for_first_player()
	move_indicator_to_active_player()
	setup_board()
	update_counts()

func reset_board():
	hex_map.clear_map()

func flip_for_first_player():
	randomize()
	if randf() >= 0.5:
		GameVariables.active_player = GameVariables.PLAYER_ONE
	else:
		GameVariables.active_player = GameVariables.PLAYER_TWO
	# yield for animation

func setup_board():
	hex_map.place_chips()

func move_indicator_to_active_player():
	if GameVariables.active_player == GameVariables.PLAYER_ONE:
		current_player_rect.rect_position = player_one_indicator_pos
	else:
		current_player_rect.rect_position = player_two_indicator_pos

func swap_active_player():
	if GameVariables.active_player == GameVariables.PLAYER_ONE:
		GameVariables.active_player = GameVariables.PLAYER_TWO
	else:
		GameVariables.active_player = GameVariables.PLAYER_ONE

func update_counts():
	player_one_chips = hex_map.chip_count(GameVariables.PLAYER_ONE)
	player_two_chips = hex_map.chip_count(GameVariables.PLAYER_TWO)
	player_one_chips_label.text = str(player_one_chips)
	player_two_chips_label.text = str(player_two_chips)
	player_one_moves = hex_map.moves_available(GameVariables.PLAYER_ONE)
	player_two_moves = hex_map.moves_available(GameVariables.PLAYER_TWO)

func check_for_win():
	if player_one_chips == 0 or player_one_moves == 0:
		$GameUI/MessageContainer/RedWinsLabel.show()
		$GameUI/MessageContainer.mouse_filter = Control.MOUSE_FILTER_STOP
	elif player_two_chips == 0 or player_two_moves == 0:
		$GameUI/MessageContainer/BlueWinsLabel.show()
		$GameUI/MessageContainer.mouse_filter = Control.MOUSE_FILTER_STOP

func _on_HexMap_move_made():
	swap_active_player()
	move_indicator_to_active_player()
	update_counts()
	check_for_win()

func _on_MessageContainer_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		start_new_game()
		$GameUI/MessageContainer/RedWinsLabel.hide()
		$GameUI/MessageContainer/BlueWinsLabel.hide()
		$GameUI/MessageContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE

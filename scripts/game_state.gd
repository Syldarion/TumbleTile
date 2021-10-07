class_name GameState
extends Reference

# See definition at bottom of file
var board_state = {}
var wins = [0, 0]


func _init():
	pass

# board_state definition
# hex_chips (dict)
# 	Key is a Vector2 of the hex's axial coordinates
#	Value is a list (bottom to top) of the chip stack
# hex_status (int)
#	0 = alive, 1 = destroyed

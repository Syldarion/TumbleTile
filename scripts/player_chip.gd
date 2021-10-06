extends Node

onready var player_one_sprite = $PlayerOneSprite
onready var player_two_sprite = $PlayerTwoSprite

var player_owner

func _ready():
	pass

func set_owner(player):
	player_owner = player
	if player == GameVariables.PLAYER_ONE:
		player_one_sprite.show()
		player_two_sprite.hide()
	else:
		player_one_sprite.hide()
		player_two_sprite.show()

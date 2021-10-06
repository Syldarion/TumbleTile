extends Node

signal move_made

export(PackedScene) var hex_node_scene
export(PackedScene) var player_chip_scene
export(int) var rings

onready var hex_parent = $Hexes
onready var chip_parent = $Chips

var hex_dirs = [
	Vector2(1, 0), Vector2(1, -1), Vector2(0, -1),
	Vector2(-1, 0), Vector2(-1, 1), Vector2(0, 1)
]

var moving_chips = false
var chips_in_hand
var move_start

var hex_map = {}

func _ready():
	setup_hex_map()

func setup_hex_map():
	for q in range(-rings, rings + 1):
		var r1 = max(-rings, -q - rings)
		var r2 = min(rings, -q + rings)
		for r in range(r1, r2 + 1):
			create_hex(q, r)
	hex_map[Vector2.ZERO].destroy()

func place_chips():
	for i in range(6):
		var dir = hex_dirs[i]
		var sub_one_dir = hex_dirs[i]
		var sub_two_dir = hex_dirs[(i-1) % 6]
		var chip_a = i % 2
		var chip_b = (i + 1) % 2
		hex_map[dir].add_chip(create_chip(chip_a))
		hex_map[dir].add_chip(create_chip(chip_a))
		hex_map[dir + sub_one_dir].add_chip(create_chip(chip_b))
		hex_map[dir + sub_one_dir].add_chip(create_chip(chip_b))
		hex_map[dir + sub_two_dir].add_chip(create_chip(chip_b))
		hex_map[dir + sub_two_dir].add_chip(create_chip(chip_b))

func create_chip(player):
	var new_chip = player_chip_scene.instance()
	chip_parent.add_child(new_chip)
	new_chip.set_owner(player)
	return new_chip

func create_hex(q, r):
	var key = Vector2(q, r)
	var new_hex_node = hex_node_scene.instance()
	hex_parent.add_child(new_hex_node)
	new_hex_node.init(q, r)
	new_hex_node.connect("node_selected", self, "_on_HexNode_node_selected")
	hex_map[key] = new_hex_node

func chip_count(player):
	var count = 0
	for chip in chip_parent.get_children():
		if chip.player_owner == player:
			count += 1
	return count

func clear_map():
	for chip in chip_parent.get_children():
		chip_parent.remove_child(chip)
		chip.queue_free()
	for hex in hex_map:
		hex_map[hex].clear_chips()
		hex_map[hex].restore()
	hex_map[Vector2.ZERO].destroy()

func moves_available(player):
	var count = 0
	for hex in hex_map:
		if hex_map[hex].destroyed:
			continue
		if hex_map[hex].controlling_player() == player:
			count += 1
	return count

func get_hex_moves(start_position, spaces):
	var moves = []
	for dir in hex_dirs:
		for space in range(1, spaces + 1):
			var move_pos = start_position + dir * space
			if move_pos in hex_map:
				moves.append(move_pos)
	return moves

func _on_HexNode_node_selected(node):
	var node_pos = Vector2(node.q, node.r)
	if moving_chips:
		finish_move(node_pos)
	else:
		start_move(node_pos, node.node_chips)

func start_move(node_pos, chips):
	if hex_map[node_pos].controlling_player() != GameVariables.active_player:
		return
	
	move_start = node_pos
	chips_in_hand = chips
	var moves = get_hex_moves(node_pos, len(chips_in_hand))
	moving_chips = true
	for move in moves:
		if not hex_map[move].destroyed:
			hex_map[move].highlight_node()
	# highlight available moves

func finish_move(node_pos):
	moving_chips = false
	
	for hex in hex_map:
		hex_map[hex].unhighlight_node()
	if hex_map[node_pos].destroyed:
		return
	
	var distance = hex_distance(move_start, node_pos)
	
	if distance > len(chips_in_hand):
		return
	
	var direction = (node_pos - move_start) / distance
	
	for i in range(distance, 0, -1):
		var node_key = move_start + direction * i
		var chip = hex_map[move_start].remove_top_chip()
		if not hex_map[node_key].destroyed:
			var full = hex_map[node_key].add_chip(chip)
			if full:
				hex_map[node_key].destroy()
				for destroyed_chip in hex_map[node_key].node_chips:
					chip_parent.remove_child(destroyed_chip)
					destroyed_chip.queue_free()
		else:
			chip_parent.remove_child(chip)
			chip.queue_free()
	
	emit_signal("move_made")

func hex_distance(a, b):
	return (abs(a.x - b.x)
			+ abs(a.x + a.y - b.x - b.y)
			+ abs(a.y - b.y)) / 2

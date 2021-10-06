class_name HexNode
extends Node2D

export(Vector2) var size
export(Color) var hex_color
export(float) var chip_vertical_spacing
export(float) var highlight_pulse_time

export(int) var q
export(int) var r

signal node_selected

var hex_width
var hex_height
var hex_colors
var destroyed = false
var is_highlighted = false
var highlight_time

var node_chips

func init(hex_q, hex_r):
	q = hex_q
	r = hex_r
	hex_width = sqrt(3) * (size.x * 1.1) * 0.5
	hex_height = 2 * (size.y * 1.1) * 0.5
	hex_colors = [hex_color, hex_color, hex_color,
				  hex_color, hex_color, hex_color]
	node_chips = []
	setup_hex_position()
	# setup_collision_shape()

func _ready():
	pass

func _process(delta):
	if is_highlighted:
		highlight_time += delta
		highlight_time = fmod(highlight_time, highlight_pulse_time)
		var lerp_percent = highlight_time / highlight_pulse_time
		# adjust 0 -> 1 to 0 -> 1 -> 0
		var lerp_adjusted = 1.0 - abs(lerp_percent - 0.5) * 2.0
		var lerp_start = Color.white
		if destroyed:
			lerp_start = Color.black
		var lerp_color = lerp(lerp_start, Color.yellow, lerp_adjusted)
		modulate = lerp_color

func pointy_hex_corner(center, size, i):
	var angle_deg = 60 * i - 30
	var angle_rad = PI / 180 * angle_deg
	return Vector2(center.x + size.x * cos(angle_rad),
				   center.y + size.y * sin(angle_rad))

func set_color(color):
	hex_colors = [color, color, color, color, color, color]

func add_chip(chip):
	chip.position = position + Vector2.UP * chip_vertical_spacing * len(node_chips)
	chip.z_index = len(node_chips)
	node_chips.append(chip)
	return len(node_chips) >= 6

func remove_top_chip():
	return node_chips.pop_back()

func clear_chips():
	node_chips = []

func destroy():
	modulate = Color.black
	destroyed = true

func restore():
	modulate = Color.white
	destroyed = false

func highlight_node():
	highlight_time = 0.0
	is_highlighted = true

func unhighlight_node():
	is_highlighted = false
	if destroyed:
		modulate = Color.black
	else:
		modulate = Color.white

func controlling_player():
	if len(node_chips) == 0:
		return -1
	return node_chips[len(node_chips) - 1].player_owner

func setup_collision_shape():
	var collision_shape = $StaticBody2D/CollisionPolygon2D
	var collision_points = []
	for i in range(6):
		collision_points.append(pointy_hex_corner(position, size, i))
	collision_shape.polygon = collision_points

func setup_hex_position():
	var x_offset = r * (hex_width * 0.5)
	position = Vector2(q * hex_width + x_offset, r * (hex_height * 0.75))

func _on_StaticBody2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print("Pressed")
		emit_signal("node_selected", self)

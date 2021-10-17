extends TextureRect


var background_color setget set_background_color, get_background_color
var hex_color setget set_hex_color, get_hex_color
var rotation setget set_rotation, get_rotation
var move_speed setget set_move_speed, get_move_speed
var repetition setget set_repetition, get_repetition
var hex_size setget set_hex_size, get_hex_size
var zoom setget set_zoom, get_zoom


func set_background_color(color):
	material.set_shader_param("bg_color", color)

func get_background_color():
	material.get_shader_param("bg_color")

func set_hex_color(color):
	material.set_shader_param("hex_color", color)

func get_hex_color():
	material.get_shader_param("hex_color")

func set_rotation(radians):
	material.set_shader_param("rot_rads", radians)

func get_rotation():
	material.get_shader_param("rot_rads")

func set_move_speed(speed_vector):
	material.set_shader_param("move_speed", speed_vector)

func get_move_speed():
	material.get_shader_param("move_speed")

func set_repetition(rep_factor):
	material.set_shader_param("rep_factor", rep_factor)

func get_repetition():
	material.get_shader_param("rep_factor")

func set_hex_size(size):
	material.set_shader_param("hex_size", size)

func get_hex_size():
	material.get_shader_param("hex_size")

func set_zoom(zoom):
	material.set_shader_param("zoom", zoom)

func get_zoom():
	material.get_shader_param("zoom")

extends Control

export(Vector2) var logo_lerp_start
export(Vector2) var logo_lerp_end
export(float) var logo_lerp_speed

onready var game_background = $GameBackground/GameBackground as TextureRect
onready var game_logo = $MenuUI/GameLogo as TextureRect
onready var tweener = $MenuUI/Tween as Tween
onready var menu_container = $MenuUI/MenuContainer as VBoxContainer
onready var continue_label = $MenuUI/PressToContinueLabel as Label

var waiting_to_continue
var moving_logo
var moving_logo_time


func _ready():
	waiting_to_continue = true

func _process(delta):
	pass

func _unhandled_input(event):
	if event is InputEventMouseButton or event is InputEventKey:
		if event.pressed and waiting_to_continue:
			continue_to_menu()

func continue_to_menu():
	print("Continuing to menu")
	waiting_to_continue = false
	start_shift_logo()

func start_shift_logo():
	tweener.interpolate_property(continue_label, "modulate", Color.white, Color(1, 1, 1, 0), logo_lerp_speed)
	tweener.interpolate_property(game_logo, "rect_position", logo_lerp_start, logo_lerp_end, logo_lerp_speed)
	if not tweener.is_active():
		tweener.start()
	yield(tweener, "tween_all_completed")
	menu_container.visible = true
	tweener.interpolate_property(menu_container, "modulate", Color(1, 1, 1, 0), Color.white, logo_lerp_speed)
	if not tweener.is_active():
		tweener.start()
	yield(tweener, "tween_all_completed")
	menu_container.mouse_filter = Control.MOUSE_FILTER_PASS

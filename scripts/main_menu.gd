extends Control

export(Vector2) var logo_lerp_start
export(Vector2) var logo_lerp_end
export(float) var logo_lerp_speed
export(float) var container_fade_speed

onready var game_background = $GameBackground/GameBackground as TextureRect
onready var game_logo = $MenuUI/GameLogo as TextureRect
onready var tweener = $MenuUI/Tween as Tween
onready var menu_container = $MenuUI/MenuContainer as VBoxContainer
onready var continue_label = $MenuUI/PressToContinueLabel as Label
onready var online_play_container = $MenuUI/OnlinePlayMenuContainer as VBoxContainer

var active_container = null
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
	tweener.interpolate_property(game_logo, "rect_position", logo_lerp_start, logo_lerp_end, logo_lerp_speed, Tween.TRANS_BACK, Tween.EASE_OUT)
	if not tweener.is_active():
		tweener.start()
	yield(tweener, "tween_all_completed")
	yield(switch_active_container(menu_container), "completed")

func switch_active_container(next_container):
	if active_container:
		tweener.interpolate_property(active_container, "modulate", Color.white, Color(1, 1, 1, 0), container_fade_speed)
		if not tweener.is_active():
			tweener.start()
		yield(tweener, "tween_all_completed")
		active_container.visible = false
		active_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	active_container = next_container
	active_container.visible = true
	active_container.modulate = Color(1, 1, 1, 0)
	tweener.interpolate_property(active_container, "modulate", Color(1, 1, 1, 0), Color.white, container_fade_speed)
	if not tweener.is_active():
		tweener.start()
	yield(tweener, "tween_all_completed")
	active_container.mouse_filter = Control.MOUSE_FILTER_PASS

func open_online_play_menu():
	switch_active_container(online_play_container)

func open_settings_menu():
	pass

func switch_from_online_to_main_menu():
	switch_active_container(menu_container)

func _on_SettingsButton_pressed():
	open_settings_menu()

func _on_QuitButton_pressed():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func _on_PlayLocalButton_pressed():
	get_tree().change_scene("res://scenes/Game.tscn")

func _on_PlayOnlineButton_pressed():
	open_online_play_menu()

func _on_HostButton_pressed():
	pass # Replace with function body.

func _on_JoinButton_pressed():
	pass # Replace with function body.

func _on_OnlineBackButton_pressed():
	switch_from_online_to_main_menu()

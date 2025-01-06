extends Node2D

var level
var player_node
var player
var alien_node
var eggs
var map

var main_ui
var sprite_timer
var wall_timer
var battery_shot_sound
var	visibility_duration = 0.8  # Duration for which sprites stay visible
var	battery_usable = true;
var eggs_hatched = false

var show_all = false
var is_ready = false

signal battery_shot_used
signal battery_not_usable
signal battery_recharge
signal battery_died

func _init() -> void:
	level = load(GlobalVariables.level).instantiate()

func _ready() -> void:
	$AmbientLoop.add_sibling(level) #done to add level before MainUi
	setup_entities()
	GlobalVariables.set_eggs_number(eggs.size())
	main_ui.terminal.setup_terminal()
	alien_node.set_player(player)
	alien_node.set_eggs(eggs)
	alien_node.set_root(self)
	player.set_root(self)
	for egg in eggs:
		egg.set_root(self)
	alien_node.start()
	main_ui.show()
	if show_all:
		main_ui.hide_ui()
	else:
		_on_wall_timer_timeout() #Hide All
	player_node.set_enemy(alien_node.get_alien())
	player_node.set_alien_node(alien_node)
	
func setup_entities():
	player_node = level.get_player_node()
	player = player_node.get_player()
	alien_node = level.get_alien_node()
	eggs = level.get_egg_nodes()
	map = level.get_map()

	main_ui = $MainUi
	sprite_timer = $SpriteTimer
	wall_timer = $WallTimer
	battery_shot_sound = $BatteryShotSound
	
	player_node.terminal = main_ui.terminal
	
func _process(_delta: float) -> void:
	if !is_ready:
		is_ready = true
		main_ui.hide_loading()
	if player:
		var noise_percentage = player.get_volume_percentage()
		main_ui.hanlde_noise_level(noise_percentage)
	else:
		push_error("player not found")
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("stun_bomb"):
		if GlobalVariables.stun_bombs > 0:
			GlobalVariables.stun_bombs -= 1
			player_node.use_bomb()
		
func start_wall_timer():
	if show_all:
		return
	if not wall_timer:
		push_error("WallTimer node not found!")
		return
	if not map:
		push_error("Wall node not found!")
		return
	wall_timer.start()
	map.show()
	alien_node.show()
	for egg in eggs:
		if !egg.broken:
			egg.show()
	
func _on_wall_timer_timeout() -> void:
	map.hide()
	alien_node.hide()
	for egg in eggs:
		if !egg.broken:
			egg.hide()
	battery_usable = true
	return	
		
func _on_battery_recharge_timer_timeout() -> void:
	if GlobalVariables.battery_shots < 6:
		battery_recharge.emit()
		GlobalVariables.battery_shots += 1

func _on_sprite_timer_timeout() -> void:
	if battery_usable == false || show_all:
		return
	# Show all sprites (alien and eggs)
	alien_node.show()
	for egg in eggs:
		if !egg.broken:
			egg.show()
	await get_tree().create_timer(visibility_duration).timeout	
	if battery_usable == false:
		return
	# Hide all sprites
	alien_node.hide()
	for egg in eggs:
		if !egg.broken:
			egg.hide()

func handle_win():
	get_tree().paused = 1
	$MainUi/HBoxContainer/Battery.hide()
	$MainUi/HBoxContainer/Terminal.hide()
	$MainUi/HBoxContainer/Radar/Control.hide()
	$MainUi/HBoxContainer/NoiseLevel.hide()
	$MainUi/VideoManager.config_and_play(load("res://Asset/Video/you_win.ogv"), _on_win_video_finished)

func handle_lose():
	get_tree().paused = 1
	$MainUi/HBoxContainer/Battery.hide()
	$MainUi/HBoxContainer/Terminal.hide()
	$MainUi/HBoxContainer/Radar/Control.hide()
	$MainUi/HBoxContainer/NoiseLevel.hide()
	$MainUi/VideoManager.config_and_play(load("res://Asset/Video/you_lose.ogv"), _on_lose_video_finished)

func _on_lose_video_finished() -> void:
	$MainUi/HBoxContainer/Terminal.display_lose_text()
	$MainUi/HBoxContainer/Battery.show()
	$MainUi/HBoxContainer/Terminal.show()
	$MainUi/HBoxContainer/NoiseLevel.show()
	$MainUi/PauseMenu.show()
	$MainUi/PauseMenu/MarginContainer/VBoxContainer/Resume.disabled = 1

func _on_win_video_finished() -> void:
	$MainUi/HBoxContainer/Terminal.display_win_text()
	$MainUi/HBoxContainer/Battery.show()
	$MainUi/HBoxContainer/Terminal.show()
	$MainUi/HBoxContainer/NoiseLevel.show()
	$MainUi/PauseMenu.show()
	$MainUi/PauseMenu/MarginContainer/VBoxContainer/Resume.disabled = 1

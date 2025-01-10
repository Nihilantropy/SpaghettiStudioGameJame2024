extends Node2D

var level
var player_node
var player
var alien_mother_node
var alien_nodes_list: Array
var eggs
var map

@onready var main_ui = $MainUi
@onready var visibility_timer = $VisibilityTimer
@onready var radar_timer = $RadarTimer  # Timer for regular radar pulses
@onready var play_time = $PlayTime

var visibility_duration = 0.8  # Duration for which sprites stay visible
var eggs_hatched = false
var show_entities: bool = true
var show_all = false
var is_ready = false

func _init() -> void:
	level = load(GlobalVariables.level).instantiate()
	
func _ready() -> void:
	$AmbientLoop.add_sibling(level) #done to add level before MainUi
	setup_entities()
	GlobalVariables.set_eggs_number(eggs.size())
	main_ui.terminal.setup_terminal()
	main_ui.terminal.root_node = self
	play_time.wait_time = 12
	play_time.start()
	
	# Start the regular radar pulse timer
	radar_timer.start()
	
func setup_entities():
	player_node = level.get_player_node()
	player = player_node.get_player()
	alien_mother_node = level.get_alien_node()
	eggs = level.get_egg_nodes()
	map = level.get_map()
	
	if alien_mother_node:
		alien_mother_node.queue_free()
	player_node.terminal = main_ui.terminal
	player.set_root(self)
	for egg in eggs:
		egg.set_root(self)
	if show_all:
		main_ui.hide_ui()
	else:
		main_ui.show()
		
func _process(_delta: float) -> void:
	if !is_ready:
		is_ready = true
		main_ui.hide_loading()
	if !eggs_hatched && play_time.time_left <= play_time.wait_time / 2:
		eggs_hatched = true
		eggs_arised()
	if player:
		var noise_percentage = player.get_volume_percentage()
		main_ui.hanlde_noise_level(noise_percentage)
	else:
		push_error("player not found")
	
func eggs_arised():
	var totalEggs = GlobalVariables.eggs_number
	main_ui.terminal.eggs_arised()
	for egg in eggs:
		egg.hatch(totalEggs)

func add_alien(new_born):
	new_born.set_player(player)
	new_born.set_eggs(eggs)
	new_born.set_root(self)
	new_born.start()
	alien_nodes_list.append(new_born)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("stun_bomb"):
		if GlobalVariables.stun_bombs > 0:
			GlobalVariables.stun_bombs -= 1
			player_node.use_bomb()
			main_ui.update_bombs()
		
func start_visibility_timer():
	if show_all:
		return
	if not visibility_timer:
		push_error("VisibilityTimer node not found!")
		return
	if not map:
		push_error("Wall node not found!")
		return
	visibility_timer.start()
	map.show()
	if show_entities:
		for alien in alien_nodes_list:
			if alien:
				alien.show()
		for egg in eggs:
			if !egg.broken:
				egg.show()

func _on_visibility_timer_timeout() -> void:
	map.hide()
	if show_entities:
		for alien in alien_nodes_list:
			if alien:
				alien.hide()
		for egg in eggs:
			if !egg.broken:
				egg.hide()

# Regular radar pulse
func _on_radar_timer_timeout() -> void:
	start_visibility_timer()

func handle_win():
	get_tree().paused = 1
	$MainUi/HBoxContainer/Terminal.hide()
	$MainUi/HBoxContainer/Radar.hide()
	$MainUi/HBoxContainer/NoiseLevel.hide()
	$MainUi/VideoManager.config_and_play(load("res://Asset/Video/you_win.ogv"), _on_win_video_finished)

func handle_lose():
	get_tree().paused = 1
	$MainUi/HBoxContainer/Terminal.hide()
	$MainUi/HBoxContainer/Radar.hide()
	$MainUi/HBoxContainer/NoiseLevel.hide()
	$MainUi/VideoManager.config_and_play(load("res://Asset/Video/you_lose.ogv"), _on_lose_video_finished)

func _on_lose_video_finished() -> void:
	$MainUi/HBoxContainer/Terminal.display_lose_text()
	$MainUi/HBoxContainer/Terminal.show()
	$MainUi/HBoxContainer/Radar.show()
	$MainUi/HBoxContainer/NoiseLevel.show()
	$MainUi/PauseMenu.show()
	$MainUi/PauseMenu/MarginContainer/VBoxContainer/Resume.disabled = 1

func _on_win_video_finished() -> void:
	$MainUi/HBoxContainer/Terminal.display_win_text()
	$MainUi/HBoxContainer/Terminal.show()
	$MainUi/HBoxContainer/Radar.show()
	$MainUi/HBoxContainer/NoiseLevel.show()
	$MainUi/PauseMenu.show()
	$MainUi/PauseMenu/MarginContainer/VBoxContainer/Resume.disabled = 1

func _on_play_time_timeout() -> void:
	handle_win()

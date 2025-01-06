extends Node2D

var level
var player_node
var player
var alien_mother_node
var alien_nodes_list: Array
var eggs
var map

@onready var sprite_timer = $SpriteTimer
@onready var main_ui = $MainUi
@onready var wall_timer = $WallTimer
@onready var battery_shot_sound = $BatteryShotSound
@onready var play_time = $PlayTime
var	visibility_duration = 0.8  # Duration for which sprites stay visible
var	battery_usable = true;
var eggs_hatched = false

var show_all = false
var is_ready = false

signal battery_shot_used
signal battery_not_usable
signal battery_recharge
signal battery_died

var resource

func _init() -> void:
	#ResourceLoader.load_threaded_request(GlobalVariables.level)
	#var progress = [0]
	#var status = ResourceLoader.load_threaded_get_status(GlobalVariables.level, progress)
	#while true:
		#if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			#status = ResourceLoader.load_threaded_get_status(GlobalVariables.level, progress)
		#elif status == ResourceLoader.THREAD_LOAD_LOADED:
			#resource = ResourceLoader.load_threaded_get(GlobalVariables.level)
			#break
		#else:
			#print(status)
			#push_error("Error loading scene")
			#get_tree().quit()
	#print("finished")
	#level = resource.instantiate()
	level = load(GlobalVariables.level).instantiate()
	
func _ready() -> void:
	$AmbientLoop.add_sibling(level) #done to add level before MainUi
	setup_entities()
	GlobalVariables.set_eggs_number(eggs.size())
	main_ui.terminal.setup_terminal()
	main_ui.terminal.root_node = self
	play_time.wait_time = 120
	play_time.start()
	
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
		_on_wall_timer_timeout() #Hide All
		
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
	main_ui.terminal.eggs_arised()
	for egg in eggs:
		egg.hatch()

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
	for alien_node in alien_nodes_list:
		alien_node.show()
	map.show()
	for egg in eggs:
		if !egg.broken:
			egg.show()
	
func _on_wall_timer_timeout() -> void:
	map.hide()
	for alien_node in alien_nodes_list:
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
	for alien_node in alien_nodes_list:
		alien_node.show()
	for egg in eggs:
		if !egg.broken:
			egg.show()
	await get_tree().create_timer(visibility_duration).timeout	
	if battery_usable == false:
		return
	# Hide all sprites
	for alien_node in alien_nodes_list:
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

func _on_play_time_timeout() -> void:
	handle_win()

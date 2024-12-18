extends Node2D

@onready var player = $PlayerNode.get_player()
@onready var main_ui = $MainUi

@onready var sprite_timer = $SpriteTimer
@onready var wall_timer = $WallTimer
@onready var eggs = [ $Egg, $Egg1, $Egg2, $Egg3 ]
@onready var alien = $AlienNode
@onready var walls = $Layer2
@onready var battery_shot_sound = $BatteryShotSound
var	visibility_duration = 0.8  # Duration for which sprites stay visible

var	battery_usable = true;

signal battery_shot_used
signal battery_not_usable
signal battery_recharge
signal battery_died

func _ready() -> void:
	alien.set_player($PlayerNode.get_player())
	alien.set_eggs([$Egg, $Egg1, $Egg2, $Egg3])
	alien.set_root(self)
	alien.start()
	_on_wall_timer_timeout() #Hide All
	$PlayerNode.set_enemy(alien.get_alien())
	$PlayerNode.alien_node = alien
	
func _process(_delta: float) -> void:
	if player:
		var noise_percentage = player.get_volume_percentage()
		main_ui.hanlde_noise_level(noise_percentage)
	else:
		push_error("player not found")
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_battery_shot"):
		if GlobalVariables.battery_shots > 0:
			if battery_usable:
				battery_usable = false
				GlobalVariables.battery_shots -= 1
				battery_shot_sound.play()
				battery_shot_used.emit()
				start_wall_timer()
			else:
				battery_not_usable.emit()
		else:
			battery_died.emit()
		
func start_wall_timer():
	if not wall_timer:
		push_error("WallTimer node not found!")
		return
	if not walls:
		push_error("Wall node not found!")
		return
	wall_timer.start()
	walls.show()
	alien.show()
	for egg in eggs:
		if !egg.broken:
			egg.show()
	
func _on_wall_timer_timeout() -> void:
	walls.hide()
	alien.hide()
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
	if battery_usable == false:
		return
	# Show all sprites (alien and eggs)
	alien.show()
	for egg in eggs:
		if !egg.broken:
			egg.show()
	await get_tree().create_timer(visibility_duration).timeout	
	if battery_usable == false:
		return
	# Hide all sprites
	alien.hide()
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

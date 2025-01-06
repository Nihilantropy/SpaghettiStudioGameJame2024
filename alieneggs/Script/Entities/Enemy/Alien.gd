extends CharacterBody2D

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var alien_node = $".."

const SLOW_SPEED = 40
const NORMAL_SPEED = 70
const MAX_SPEED = 500

var rng = RandomNumberGenerator.new()
var speed = NORMAL_SPEED
var player = null
var eggs = null
var egg = null
var target = null
var in_player_area = 0
var is_stun = false

func start():
	change_target(0)
	for each in eggs:
		each.alien = self

func _physics_process(_delta: float) -> void:
		if is_stun:
			return
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed
		move_and_slide()
		
func stun(time):
	$"../StunTime".wait_time = time
	$"../StunTime".start()
	is_stun = true
		
func makePath() -> void:
	#if target == egg:
		#if egg.broken:
			#change_target(0)
	nav_agent.target_position = target.global_position

func make_noise():
	var pitch_value = rng.randf_range(0.75, 1.3)
	var sound: AudioStreamPlayer
	match rng.randi_range(1, 3):
		1:
			sound = $"../Verse1Far"
		2:
			sound = $"../Verse2Far"
		3:
			sound = $"../Verse3Far"
	sound.pitch_scale = pitch_value
	sound.play()

func choose_new_egg():
	egg = eggs[rng.randi_range(0, GlobalVariables.eggs_max_number - 1)]
	
func _on_timer_timeout() -> void:
		makePath()

func change_target(in_out):
	in_player_area += in_out
	if in_player_area:
		if (speed != MAX_SPEED):
			speed = SLOW_SPEED
		target = player
	else:
		choose_new_egg()
		target = egg
	
func got_in_noise_area():
	change_target(+1)
	speed = MAX_SPEED
	
func got_out_noise_area():
	change_target(-1)
	speed = NORMAL_SPEED
	
func _on_stun_time_timeout() -> void:
	is_stun = false

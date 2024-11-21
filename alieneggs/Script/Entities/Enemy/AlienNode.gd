extends Node2D

@onready var alien = $AlienBody
var rng = RandomNumberGenerator.new()
var player = null
var eggs = null
var root_node = null
var player_hear = false

var minimap_icon = "alien"

func get_alien():
	return alien

func set_player(body):
	$AlienBody.player = body
	player = body
	
func set_eggs(bodies):
	$AlienBody.eggs = bodies
	eggs = bodies
	
func set_root(node):
	root_node = node
	
func start():
	$AlienBody.start()
	
func startNoises():
	player_hear = true
	$NoiseTimer.start()

func stopNoises():
	player_hear = false
	
func _on_noise_timer_timeout() -> void:
	if player_hear:
		$AlienBody.make_noise()
		$NoiseTimer.wait_time = rng.randf_range(2, 4)
		$NoiseTimer.start()
		
func make_growl_far_sound():
	$GrowlFar.pitch_scale = rng.randf_range(0.8, 1.2)
	$GrowlFar.play()
	
func make_growl_near_sound():
	$GrowlNear.pitch_scale = rng.randf_range(0.8, 1.2)
	$GrowlNear.play()

extends CharacterBody2D

@onready var noise_area_collision = $NoiseArea/CollisionShape

#Questo valore indica il tempo di secondi che ci mette il player 
#a raggiungere la massima velocità restando premuto il tasto
#va cappato perche altrimenti non decellera subito quando sollevi il tasto
#va ricalcolato ogni volta che si modifica la curva di accellerazione
const MAX_TIME = 1.5

const ACCEL_LIMIT = 700.0
const ACCEL_FIXED = 3  # Velocità di crescita (regolabile)
const DECEL_FIXED = 1.5  # Velocità di crescita (regolabile)
var seconds_pressed = 0
var rng = RandomNumberGenerator.new()
var movement = Vector2()
var last_movement = Vector2()
var speed = 0
var on_wall_flag = false
var enemy_hearable = false
var root_node = null
var current_walk: AudioStreamPlayer = null
var playing_walk: AudioStreamPlayer = null

func _ready():
	if (!GlobalVariables.is_mother_mode()):
		$RadarArea/CollisionShape.shape.radius = 2024

func _process(_delta: float) -> void:
	if GlobalVariables.eggs_number == 0 && !root_node.eggs_hatched:
		root_node.handle_win()
	if current_walk != playing_walk:
		if (playing_walk):
			playing_walk.stop()
		playing_walk = current_walk
		if playing_walk:
			playing_walk.play()
	
func _physics_process(delta: float) -> void:
	calc_velocity(delta)
	move_and_slide()
	update_noise()
	check_collision()

func set_root(root):
	root_node = root
	
func set_current_walk():
	var vol_perc = get_volume_percentage()
	if vol_perc < 1:
		current_walk = null
	elif vol_perc < 30:
		current_walk = $"../WalkSlow"
	elif vol_perc < 60:
		current_walk = $"../WalkNormal"
	else:
		current_walk = $"../WalkFast"
	
func calc_velocity(delta):
	var is_accelerating = 0
	
	movement.x = Input.get_axis("left_mov", "right_mov")
	movement.y = Input.get_axis("up_mov", "down_mov")
	#movement.normalized()
	is_accelerating = max(abs(movement.x), abs(movement.y))
	if (is_accelerating):
		seconds_pressed += delta
		if (seconds_pressed > MAX_TIME):
			seconds_pressed = MAX_TIME
		last_movement = movement
	else:
		seconds_pressed -= delta * DECEL_FIXED \
		 				if seconds_pressed >= delta * DECEL_FIXED else seconds_pressed
		movement = last_movement
	speed = get_acceleration()
	velocity = movement * speed

func check_collision():
	if is_on_wall():
		if !on_wall_flag:
			$"../Wall".pitch_scale = rng.randf_range(0.9, 1.1)
			$"../Wall".play()
			seconds_pressed /= 3
		on_wall_flag = 1
	if !is_on_wall():
		on_wall_flag = 0

func get_acceleration():
	return ACCEL_LIMIT * (1 - exp(ACCEL_FIXED * -seconds_pressed))

func update_noise():
	set_current_walk()
	update_noise_area()

func update_noise_area():
	#2000px max, 20px min
	var min_area = 20
	noise_area_collision.shape.radius = min_area + get_noise_area_increm()

func get_volume_percentage():
	return (speed * 100) / ACCEL_LIMIT

func get_noise_area_increm():
	return (1980 * get_volume_percentage()) / 100
	

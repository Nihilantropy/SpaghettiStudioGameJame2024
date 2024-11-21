extends CharacterBody2D

@onready var noise_area_collision = $NoiseArea/CollisionShape

const ACCEL_LIMIT = 500.0
const ACCEL_FIXED = 1.0
var rng = RandomNumberGenerator.new()
var movement = Vector2()
var last_movement = Vector2()
var speed = 0
var on_wall_flag = false
var enemy_hearable = false
var root_node = null
var current_walk: AudioStreamPlayer = null
var playing_walk: AudioStreamPlayer = null


func _process(_delta: float) -> void:
	if GlobalVariables.eggs_number == 0:
		root_node.handle_win()
	if current_walk != playing_walk:
		if (playing_walk):
			playing_walk.stop()
		playing_walk = current_walk
		if playing_walk:
			playing_walk.play()
	

func _physics_process(_delta: float) -> void:
	calc_velocity()
	move_and_slide()
	update_noise()
	check_collision()

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
	
func calc_velocity():
	if Input.is_action_pressed("ui_up"):
		movement.y -= 1
	if Input.is_action_pressed("ui_down"):
		movement.y += 1
	if Input.is_action_pressed("ui_left"):
		movement.x -= 1
	if Input.is_action_pressed("ui_right"):
		movement.x += 1
	if ( !Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_down") and !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right")):
		speed -= 5
		if speed <= 0:
			speed = 0
		print("decelerando, speed:", speed)
	else:
		speed += 10

	# Silenziando queste due righe fa effetto gravità
	if speed <= 0:
		movement = Vector2.ZERO

	if speed >= 500:
		speed = 500  # Normalizza la direzione per avere velocità costante anche in diagonale
	movement = movement.normalized()
	 #lizza la direzione per avere velocità costante anche in diagonale
	

	#var is_accelerating = 0
	#
	#movement.x = Input.get_axis("ui_left", "ui_right")
	#movement.y = Input.get_axis("ui_up", "ui_down")
	#movement.normalized()
	#accelerating_matt_method(is_accelerating)
	#if (is_accelerating):
		#speed += (ACCEL_FIXED if (speed <= (ACCEL_LIMIT - 1.1)) else 0.0)
		#last_movement = movement
	#else:
		#if speed > 80:
			#speed /= 1.01
		#else:
			#speed = 0
		#if speed:
			#movement = last_movement
	velocity = movement * speed

func check_collision():
	if is_on_wall():
		if !on_wall_flag:
			$"../Wall".pitch_scale = rng.randf_range(0.9, 1.1)
			$"../Wall".play()
			speed /= 3.5
		on_wall_flag = 1
	if !is_on_wall():
		on_wall_flag = 0

func accelerating_matt_method(is_accelerating):
	if (is_accelerating):
		speed += 5
	else:
		
		speed -= 5
		if speed <= 0:
			print("fermo", speed)
			speed = 0
	if speed >= ACCEL_LIMIT:
		speed = ACCEL_LIMIT

func update_noise():
	set_current_walk()
	update_noise_area()

func update_noise_area():
	#850px max, 100px min
	var min_area = 50
	noise_area_collision.shape.radius = min_area + get_noise_area_increm()

func get_volume_percentage():
	#if speed < 100
	return (speed * 100) / 500

func get_noise_area_increm():
	return (750 * get_volume_percentage()) / 100
	
signal egg_broken

func egg_destroyed() -> void:
	emit_signal("egg_broken")

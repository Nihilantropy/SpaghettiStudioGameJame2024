extends Control

@export var wait_time: float = 1.5:
	set(value):
		wait_time = value
		if material_assigned:
			shader_mat.set_shader_parameter("wait_time", wait_time)

@onready var color_rect = $Control/ColorRect
@onready var color_rect2 = $Control/ColorRect/ColorRect2
@onready var color_rect3 = $Control/ColorRect/ColorRect2/ColorRect3

var game_mode = null
signal sonar_fire

var shader_mat: ShaderMaterial
var material_assigned := false
var last_animation_cycle := -1.0

func _ready() -> void:
	color_rect.hide()
	_setup_shader()
	
func set_game_mode(mode):
	game_mode = mode
	sonar_fire.connect(game_mode._on_sonar_fire)

func _setup_shader() -> void:
	shader_mat = ShaderMaterial.new()
	shader_mat.shader = preload("res://Scene/UI/ring_wave/ring_wave.gdshader")
	shader_mat.set_shader_parameter("circle_width", 0.1)
	shader_mat.set_shader_parameter("wait_time", wait_time)
	shader_mat.set_shader_parameter("speed", 0.5)
	shader_mat.set_shader_parameter("alpha_boost", 1.5)
	shader_mat.set_shader_parameter("circle_color", Color(0, 1, 0, 1))

func _process(_delta: float) -> void:
	if not material_assigned:
		return
	
	var current_time = Time.get_ticks_msec() / 1000.0
	shader_mat.set_shader_parameter("time", current_time)
	
	# Match shader's animation cycle
	var current_cycle = floor(current_time * shader_mat.get_shader_parameter("speed") / (0.75 + wait_time))
	if current_cycle > last_animation_cycle:
		sonar_fire.emit()
	last_animation_cycle = current_cycle

func _on_sonar_start_timer_timeout() -> void:
	if material_assigned:
		return
	
	color_rect.material = shader_mat
	color_rect2.material = shader_mat
	color_rect3.material = shader_mat
	material_assigned = true
	color_rect.show()
	sonar_fire.emit()

extends Control

@onready var color_rect = $Control/ColorRect
@onready var color_rect2 = $Control/ColorRect/ColorRect2
@onready var color_rect3 = $Control/ColorRect/ColorRect2/ColorRect3

signal sonar_fire

var last_mod_time = 0.0
var material_assigned = false

func _ready() -> void:
	color_rect.hide()

func _process(_delta):
	if material_assigned:
		# Update the shader's time uniform using Time singleton
		var current_time = Time.get_ticks_msec() / 1000.0  # Convert milliseconds to seconds
		color_rect.material.set("shader_parameter/time", current_time)
		
		# Calculate the mod_time to detect when the circle starts
		var wait_time = color_rect.material.get("shader_parameter/wait_time")
		var speed = color_rect.material.get("shader_parameter/speed")
		var mod_time = fmod(current_time * speed, 0.75 + wait_time)
		
		# Emit the signal when the circle starts
		if mod_time < last_mod_time:
			sonar_fire.emit()
		
		last_mod_time = mod_time

func _on_sonar_start_timer_timeout() -> void:
	# Assign the material to the ColorRect when the timer finishes
	if not material_assigned:
		var shader_mat = ShaderMaterial.new()  # Changed variable name from 'material' to 'shader_mat'
		shader_mat.shader = preload("res://Scene/UI/ring_wave/ring_wave.gdshader")
		
		# Set default values for the shader parameters
		shader_mat.set("shader_parameter/circle_width", 0.1)
		shader_mat.set("shader_parameter/wait_time", 0.3)
		shader_mat.set("shader_parameter/speed", 0.5)
		shader_mat.set("shader_parameter/alpha_boost", 1.5)
		shader_mat.set("shader_parameter/circle_color", Color(0, 1, 0, 1))
		
		color_rect.material = shader_mat
		color_rect2.material = shader_mat
		color_rect3.material = shader_mat
		material_assigned = true
		color_rect.show()
		sonar_fire.emit()

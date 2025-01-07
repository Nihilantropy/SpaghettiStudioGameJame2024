extends Node

signal sonar_fire

@onready var player = get_parent()
@onready var noise_level = $HBoxContainer/NoiseLevel
@onready var terminal = $HBoxContainer/Terminal
@onready var radar = $HBoxContainer/Radar

func hanlde_noise_level(noise_percentage):
	noise_level.update_noise_bar(noise_percentage)

func hide_ui():
	$HBoxContainer.hide()
	$ColorRect.hide()

func _ready() -> void:
	radar.connect("sonar_fire", Callable(self, "_on_sonar_fire"))
	$PauseMenu.radarShader = $HBoxContainer/Radar/Control
	
func update_bombs():
	terminal.update_bombs()
	
func hide_loading():
	$LoadingImage.hide()

func _on_sonar_fire():
	emit_signal("sonar_fire")

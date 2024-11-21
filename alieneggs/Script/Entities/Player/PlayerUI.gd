extends Node

@onready var player = get_parent()
@onready var noise_level = $HBoxContainer/NoiseLevel
@onready var battery = $HBoxContainer/Battery
@onready var terminal = $HBoxContainer/Terminal

func hanlde_noise_level(noise_percentage):
	noise_level.update_noise_bar(noise_percentage)

func hide_ui():
	$HBoxContainer.hide()
	$ColorRect.hide()

func _ready() -> void:
	$PauseMenu.radarShader = $HBoxContainer/Radar/Control

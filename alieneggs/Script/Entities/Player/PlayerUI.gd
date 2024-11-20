extends Node

@onready var player = get_parent()
@onready var noise_level = get_node("HBoxContainer/NoiseLevel")

func hanlde_noise_level(noise_percentage):
	noise_level.update_noise_bar(noise_percentage)
func handle_radar():
	pass

func _ready() -> void:
	$PauseMenu.radarShader = $HBoxContainer/Radar/Control

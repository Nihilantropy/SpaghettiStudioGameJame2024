extends Node

@onready var player = get_parent()
@onready var noise_level = get_node("HBoxContainer/NoiseLevel")

signal battery_shot_used
signal battery_not_usable
signal battery_recharge
signal battery_died
signal update_egg

func hanlde_noise_level(noise_percentage):
	noise_level.update_noise_bar(noise_percentage)
func handle_radar():
	pass

func _ready() -> void:
	$PauseMenu.radarShader = $HBoxContainer/Radar/Control


func _on_game_manager_battery_shot_used() -> void:
	emit_signal("battery_shot_used")

func _on_game_manager_battery_died() -> void:
	emit_signal("battery_died")

func _on_game_manager_battery_recharge() -> void:
	emit_signal("battery_recharge")

func _on_game_manager_update_egg() -> void:
	emit_signal("update_egg")

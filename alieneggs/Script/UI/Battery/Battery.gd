extends Node

@onready var battery_texture = [
	$Control/BatteryLevel0,
	$Control/BatteryLevel1,
	$Control/BatteryLevel2,
	$Control/BatteryLevel3,
	$Control/BatteryLevel4,
	$Control/BatteryLevel5,
	$Control/BatteryLevel6 ]

func _ready() -> void:
	for battery in battery_texture:
			battery.hide()
	# Show the current battery level texture
	battery_texture[6].show()

func _on_game_battery_shot_used() -> void:
	# Ensure the global variable exists and is valid
	if GlobalVariables.battery_shots >= 0 and GlobalVariables.battery_shots < battery_texture.size():
		# Hide all battery textures
		for battery in battery_texture:
			battery.hide()
		# Show the current battery level texture
		battery_texture[GlobalVariables.battery_shots].show()
	else:
		push_error("Invalid battery level: ", GlobalVariables.battery_shots)


func _on_game_battery_recharge() -> void:
	# Ensure the global variable exists and is valid
	if GlobalVariables.battery_shots < 7:
		# Hide all battery textures
		for battery in battery_texture:
			battery.hide()
		# Show the current battery level texture
		battery_texture[GlobalVariables.battery_shots + 1].show()
	else:
		push_error("Invalid battery level: ", GlobalVariables.battery_shots)

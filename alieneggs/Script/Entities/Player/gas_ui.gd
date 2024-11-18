extends Control

# Array to hold the TextureRect nodes
@onready var gas_images = [
	get_node("SpeedometerContainer/SpeedometerImage1"),
	get_node("SpeedometerContainer/SpeedometerImage2"),
	get_node("SpeedometerContainer/SpeedometerImage3"),
	get_node("SpeedometerContainer/SpeedometerImage4"),
	get_node("SpeedometerContainer/SpeedometerImage5"),
	get_node("SpeedometerContainer/SpeedometerImage6"),
]

@onready var gas_stick = get_node("StickContainer/GasStick")  # Reference to your gas stick node

# Updates the displayed image based on the gas level
func update_speedometer_image(gas_level: int) -> void:
	# Hide all images first
	for image in gas_images:
		image.visible = false
	
	# Reverse the order of gas levels for correct image display
	var index_to_show = 5 - gas_level  # Invert the level so that 0 corresponds to GasImage6 (empty)
	
	# Show the image that matches the current gas level
	if index_to_show >= 0 and index_to_show < gas_images.size():
		gas_images[index_to_show].visible = true

# Update the gas stick rotation based on a float gas level
func update_gas_stick_image(rotation_angle: float) -> void:
	gas_stick.rotation_degrees = rotation_angle
	#print("gas stick rotation degrees: ", gas_stick.rotation_degrees)

extends Control

@onready var terminal_text = $Screen/Messages
@onready var terminal_info_text = $Screen/Info

func _ready() -> void:
	# Set up the terminal style
	terminal_text.clear()
	terminal_text.bbcode_enabled = true
	terminal_text.scroll_active = true
	terminal_text.scroll_following = true

	# Set font properties and colors
	terminal_text.add_theme_color_override("default_color", Color(0, 1, 0)) # Terminal green
	terminal_text.add_theme_color_override("default_bg_color", Color(0, 0, 0)) # Black background

	var font = FontFile.new()
	font.fixed_size = 14
	font.font_data = load("res://Script/UI/Terminal/Font/Courier MonoThai Regular.ttf") # Replace with the correct path
	terminal_text.add_theme_font_override("default_font", font)

	# Set up the terminal style
	terminal_info_text.clear()
	terminal_info_text.bbcode_enabled = true
	terminal_info_text.scroll_active = true
	terminal_info_text.scroll_following = true

	# Set font properties and colors
	terminal_info_text.add_theme_color_override("default_color", Color(0, 1, 0)) # Terminal green
	terminal_info_text.add_theme_color_override("default_bg_color", Color(0, 0, 0)) # Black background

	terminal_info_text.add_theme_font_override("default_font", font)
	
	update_messages_terminal("Welcome to The Terminal")
	update_info_terminal("Press space to shoot a battery")
	
	
	
# Reusable function to update terminal text
func update_messages_terminal(message: String) -> void:
	terminal_text.clear()
	terminal_text.add_text(message)

func update_info_terminal(message: String) -> void:
	terminal_info_text.clear()
	terminal_info_text.add_text(message)


# Signal handlers to update the terminal
func _on_main_ui_battery_shot_used() -> void:
	# Set font properties and colors
	terminal_text.add_theme_color_override("default_color", Color(1, 1, 0))

	var font = FontFile.new()
	font.fixed_size = 14
	font.font_data = load("res://Script/UI/Terminal/Font/Courier MonoThai Regular.ttf") # Replace with the correct path
	terminal_text.add_theme_font_override("default_font", font)
	update_messages_terminal("Battery shot used!")

func _on_main_ui_battery_died() -> void:
	# Set font properties and colors
	terminal_text.add_theme_color_override("default_color", Color(1, 0, 0))

	var font = FontFile.new()
	font.fixed_size = 14
	font.font_data = load("res://Script/UI/Terminal/Font/Courier MonoThai Regular.ttf") # Replace with the correct path
	terminal_text.add_theme_font_override("default_font", font)
	update_messages_terminal("Battery is dead...")

func _on_main_ui_battery_recharge() -> void:
		# Set font properties and colors
	terminal_text.add_theme_color_override("default_color", Color(0, 1, 1))

	var font = FontFile.new()
	font.fixed_size = 14
	font.font_data = load("res://Script/UI/Terminal/Font/Courier MonoThai Regular.ttf") # Replace with the correct path
	terminal_text.add_theme_font_override("default_font", font)
	update_messages_terminal("Battery shot recharged!")


func _on_main_ui_update_egg() -> void:
	# Set font properties and colors
	terminal_info_text.add_theme_color_override("default_color", Color(0, 1, 1))

	var font = FontFile.new()
	font.fixed_size = 14
	font.font_data = load("res://Script/UI/Terminal/Font/Courier MonoThai Regular.ttf") # Replace with the correct path
	terminal_info_text.add_theme_font_override("default_font", font)
	var text = "Egg to destroy: " + str(GlobalVariables.eggs_number)
	update_info_terminal(text)

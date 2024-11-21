extends Control

@onready var terminal_text = $Screen/Messages
@onready var terminal_info_text = $Screen/Info
@onready var terminal_goal_text: RichTextLabel = $Screen/Goal

var font

func setup_terminal() -> void:
	font = FontFile.new()
	font.fixed_size = 14
	font.font_data = load("res://Script/UI/Terminal/Font/Courier MonoThai Regular.ttf")
	
	setup_terminal_text(terminal_text)
	setup_terminal_text(terminal_info_text)
	setup_terminal_text(terminal_goal_text)
	
	show_info_standard()
	show_goal()
	
func setup_terminal_text(textLabel):
	textLabel.clear()
	
	textLabel.add_theme_color_override("default_color", Color(0, 1, 0)) # Terminal green
	textLabel.add_theme_color_override("default_bg_color", Color(0, 0, 0)) # Black background
	textLabel.add_theme_font_override("default_font", font)
	
func update_messages_terminal(message: String) -> void:
	terminal_text.clear()
	terminal_text.add_text(message)

func update_info_terminal(message: String) -> void:
	terminal_info_text.clear()
	terminal_info_text.add_text(message)

func update_goal_terminal(message: String) -> void:
	terminal_goal_text.clear()
	terminal_goal_text.add_text(message)

func show_goal():
	var text
	
	terminal_goal_text.add_theme_color_override("default_color", Color(0, 1, 0))
	text = "Find and destroy all the eggs:\n   Eggs Remaining: " + str(GlobalVariables.eggs_number)
	update_goal_terminal(text)

func show_info_standard():
	var text
	
	terminal_info_text.add_theme_color_override("default_color", Color(1, 1, 0))
	text ="Press space to shoot a battery and boost the radar"
	update_info_terminal(text)

func _on_game_battery_shot_used() -> void:
	terminal_text.add_theme_color_override("default_color", Color(1, 1, 0))
	update_messages_terminal("Battery shot used!")

func _on_game_battery_recharge() -> void:
	terminal_text.add_theme_color_override("default_color", Color(0, 1, 1))
	update_messages_terminal("Battery shot recharged!")
	show_info_standard()

func _on_game_battery_died() -> void:
	terminal_info_text.add_theme_color_override("default_color", Color(1, 0, 0))
	update_info_terminal("Battery is dead...\nWait for the recharge")

func update_egg() -> void:
	terminal_text.add_theme_color_override("default_color", Color(0, 1, 1))
	var text = "Egg destroied: " + str(GlobalVariables.eggs_number)
	update_messages_terminal(text)
	show_goal()

func display_lose_text():
	terminal_text.clear()
	terminal_info_text.clear()
	terminal_goal_text.clear()
	terminal_goal_text.add_theme_color_override("default_color", Color(1, 0, 0))
	update_goal_terminal(" GAME OVER: The Alien Mother has killed you!")

func display_win_text():
	terminal_text.clear()
	terminal_info_text.clear()
	terminal_goal_text.clear()
	terminal_goal_text.add_theme_color_override("default_color", Color(0, 1, 0))
	update_goal_terminal(" YOU WON: The rescue has arrived")

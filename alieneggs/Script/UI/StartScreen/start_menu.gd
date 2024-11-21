extends MarginContainer

func _on_play_pressed() -> void:
	$MainMenu.visible = 0
	$PlayMenu.visible = 1

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_level_1_pressed() -> void:
	hide()
	GlobalVariables.level = "res://Scene/Game/Level1.tscn"
	GlobalVariables.game_mode = GlobalVariables.MOTHERMODE
	get_tree().paused = 1
	$"../VideoManager".config_and_play(load("res://Asset/Video/video_intro.ogv"), _on_intro_video_finished)

func _on_level_2_pressed() -> void:
	hide()
	GlobalVariables.level = "res://Scene/Game/Level1.tscn"
	GlobalVariables.game_mode = GlobalVariables.CHILDMODE
	get_tree().paused = 1
	$"../VideoManager".config_and_play(load("res://Asset/Video/video_intro.ogv"), _on_intro_video_finished)

func _on_back_pressed() -> void:
	$MainMenu.visible = 1
	$PlayMenu.visible = 0

func _on_intro_video_finished() -> void:
	get_tree().paused = 0
	get_tree().change_scene_to_file("res://Scene/Game/MotherGame.tscn")

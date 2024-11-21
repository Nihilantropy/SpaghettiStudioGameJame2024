extends MarginContainer



func _on_play_pressed() -> void:
	$MainMenu.visible = 0
	$PlayMenu.visible = 1

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_level_1_pressed() -> void:
	hide()
	#$"../AmbientLoop".stop()
	#$"../IntroVideo".play()
	get_tree().change_scene_to_file("res://Scene/Game/GameTemplate.tscn")


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("")


func _on_back_pressed() -> void:
	$MainMenu.visible = 1
	$PlayMenu.visible = 0


func _on_intro_video_finished() -> void:
	get_tree().change_scene_to_file("res://Scene/Game/GameTemplate.tscn")

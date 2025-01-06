extends Node

const MOTHERMODE = "mother_mode"
const CHILDMODE = "child_mode"

var eggs_max_number

var	eggs_number

var battery_shots = 6

var	stun_bombs = 3

var current_video: VideoStreamPlayer = null

var level = null

var game_mode = MOTHERMODE

func is_mother_mode() -> bool:
	return game_mode == MOTHERMODE

func set_eggs_number(n):
	eggs_max_number = n
	eggs_number = eggs_max_number

func is_video_playing():
	if current_video && current_video.is_playing():
		return true
	return false

func reset_globals():
	eggs_number = eggs_max_number
	stun_bombs = 3

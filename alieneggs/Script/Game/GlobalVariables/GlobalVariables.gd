extends Node

var	eggs_number = 4

var	battery_shots = 6

var current_video: VideoStreamPlayer = null

func is_video_playing():
	if current_video && current_video.is_playing():
		return true
	return false

func reset_globals():
	eggs_number = 4
	battery_shots = 6

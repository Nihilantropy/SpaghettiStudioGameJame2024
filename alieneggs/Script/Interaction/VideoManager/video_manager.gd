extends Control

@onready var SkipLabel: Label = $SkipLabel
@onready var VideoPlayer: VideoStreamPlayer = $VideoPlayer
@onready var progress: TextureProgressBar = $SkipLabel/ClockwiseProgress

const _SKIPPING_TIME = 1

var _finishing_function: Callable = Callable()
var _pressed_time = 0

func _ready() -> void:
	GlobalVariables.current_video = VideoPlayer

func _process(delta: float) -> void:
	if SkipLabel.visible:
		if !VideoPlayer.is_playing():
			stop()
		_pressed_time += (1 if Input.is_action_pressed("Pause") else -1) * delta
		_pressed_time = max(_pressed_time, 0)
		progress.value = _pressed_time * 100
		if VideoPlayer && _pressed_time >= _SKIPPING_TIME:
			stop()
			_pressed_time = 0
		
func play():
	if VideoPlayer.get_stream():
		show()
		VideoPlayer.play()
		SkipLabel.show()
		
func stop():
	VideoPlayer.stop()
	hide()
	if _finishing_function.is_valid():
		_finishing_function.call()
	clear()
		
func set_stream(stream: VideoStream):
	VideoPlayer.set_stream(stream)
	
func set_finishing_function(function: Callable):
	_finishing_function = function
	
func config_and_play(stream: VideoStream, function: Callable):
	set_stream(stream)
	set_finishing_function(function)
	play()
	
func clear():
	set_stream(null)
	set_finishing_function(Callable())
	SkipLabel.hide()

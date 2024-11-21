extends Node2D

@onready var collision = $Egg/Area2D/CollisionShape2D

var rng = RandomNumberGenerator.new()
var alien = null
var root_node = null
var broken = false

signal egg_broken

func set_root(node):
	root_node = node
	connect_signal()
	
func connect_signal():
	egg_broken.connect(root_node.main_ui.terminal.update_egg)
	
func get_broke():
	broken = true
	GlobalVariables.eggs_number -= 1
	$BrokenEgg.pitch_scale = rng.randf_range(0.8, 1.2)
	$BrokenEgg.play()
	hide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if broken:
		return
	if body.is_in_group("enemy"):
		alien.change_target(0)
	if body.is_in_group("player"):
		get_broke()
		egg_broken.emit()

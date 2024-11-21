extends Node2D

@onready var collision = $Egg/Area2D/CollisionShape2D

var rng = RandomNumberGenerator.new()
var alien = null
var root_node = null
var broken = false

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
		var player = body
		get_broke()
		player.egg_destroyed()

extends Node2D

@onready var collision = $Egg/Area2D/CollisionShape2D

var rng = RandomNumberGenerator.new()
var alien = null
var root_node = null
var broken = false
var new_born = null

signal egg_broken

func _ready() -> void:
	new_born = preload("res://Scene/Entities/Enemy/alien.tscn").instantiate()

func hatch(totalEggs):
	if broken:
		return
	get_broke(0)
	show()
	$Egg.hide()
	add_child(new_born)
	new_born.get_alien().setPathTimer(0.1 * totalEggs)
	root_node.add_alien(new_born)

func set_root(node):
	root_node = node
	connect_signal()
	
func connect_signal():
	egg_broken.connect(root_node.main_ui.terminal.update_egg)
	
func get_broke(from_player):
	broken = true
	if from_player:
		GlobalVariables.eggs_number -= 1
	$BrokenEgg.pitch_scale = rng.randf_range(0.8, 1.2)
	$BrokenEgg.play()
	hide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.change_target(0)
	if body.is_in_group("player"):
		if broken:
			return
		get_broke(1)
		egg_broken.emit()

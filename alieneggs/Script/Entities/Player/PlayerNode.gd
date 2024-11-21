extends Node2D

@onready var player = $PlayerBody
var enemy = null
var alien_node = null

func get_player():
	return player
	
func set_enemy(body):
	enemy = body
	
func set_alien_node(node):
	alien_node = node

func _on_sound_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		alien_node.startNoises()

func _on_sound_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		alien_node.stopNoises()
		
func _on_radar_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemy.change_target(+1)
		alien_node.make_growl_near_sound()

func _on_radar_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemy.change_target(-1)
		alien_node.make_growl_far_sound()

func _on_noise_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemy.got_in_noise_area()
		$Heartbeat.play()
		
func _on_noise_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemy.got_out_noise_area()
		$Heartbeat.stop()

func _on_dead_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		player.root_node.handle_lose()

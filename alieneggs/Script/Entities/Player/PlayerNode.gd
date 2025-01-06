extends Node2D

@onready var player = $PlayerBody
var enemy = null
var alien_node = null
var terminal = null
var bombPath = "res://Scene/Entities/Player/stun_bomb.tscn"

func get_player():
	return player
	
func set_enemy(body):
	enemy = body
	
func set_alien_node(node):
	alien_node = node

func use_bomb():
	var bombNode: Node2D = load(bombPath).instantiate()
	bombNode.set_position(player.position)
	$Heartbeat.add_sibling(bombNode)
	bombNode.start_animation()
	bombNode.set_body_to_stun(enemy)

func _on_sound_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.alien_node.startNoises()
		terminal.enemy_in_sound()

func _on_sound_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.alien_node.stopNoises()
		terminal.enemy_out_sound()
		
func _on_radar_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.change_target(+1)
		body.alien_node.make_growl_near_sound()
		terminal.enemy_in_radar()

func _on_radar_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.change_target(-1)
		body.alien_node.make_growl_far_sound()
		terminal.enemy_out_radar()

func _on_noise_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.got_in_noise_area()
		$Heartbeat.play()
		terminal.enemy_in_noise()
		
func _on_noise_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.got_out_noise_area()
		$Heartbeat.stop()
		terminal.enemy_out_noise()

func _on_dead_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		player.root_node.handle_lose()

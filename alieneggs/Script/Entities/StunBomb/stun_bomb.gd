extends Node2D

var activeTime = 1.5
var timeFromExplosion = 0

func _process(delta: float) -> void:
	var bodyToStun = null
	
	timeFromExplosion += delta
	bodyToStun = get_enemy_in()
	if bodyToStun and !bodyToStun.is_stun:
		bodyToStun.stun(activeTime - timeFromExplosion)

func start_animation():
	$Area/AnimatedSprite2D.play()
	$Audio.play()
	
func get_enemy_in():
	for body in $Area.get_overlapping_bodies():
		if body.is_in_group("enemy"):
			return body
	return null

func _on_animated_sprite_2d_animation_finished() -> void:
	get_parent().remove_child(self)

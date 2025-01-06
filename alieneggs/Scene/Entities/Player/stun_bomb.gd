extends Node2D

var has_stun = false
var bodyToStun = null
var activeTime = 1.5
var timeFromExplosion = 0

func _process(delta: float) -> void:
	timeFromExplosion += delta
	if bodyToStun and !has_stun:
		if is_body_in():
			bodyToStun.stun(activeTime - timeFromExplosion)
			has_stun = true

func start_animation():
	$Area/AnimatedSprite2D.play()

func is_body_in():
	return (bodyToStun in $Area.get_overlapping_bodies())
	
func set_body_to_stun(body):
	bodyToStun = body

func _on_animated_sprite_2d_animation_finished() -> void:
	get_parent().remove_child(self)

extends KinematicBody2D

export var fall_speed = 400

func _process(delta):
	position.y += fall_speed * delta

func _body_entered(body):
	if body.is_in_group("Player"):
		body.damage()

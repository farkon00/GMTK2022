extends RigidBody2D

export var bullet_speed = 700
var initial = Vector2.ZERO
func create(pos: Vector2, to: Vector2):
	initial = pos
	self.global_position = pos
	var dir = (to - position).normalized()
	self.linear_velocity = dir * bullet_speed

func _process(_delta):
	if (self.global_position - initial).length() > 10000:
		free()

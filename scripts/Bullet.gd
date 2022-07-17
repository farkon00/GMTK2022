extends RigidBody2D
class_name Bullet

export var bullet_speed = 700
var initial = Vector2.ZERO
func create(pos: Vector2, to: Vector2):
	initial = pos
	self.global_position = pos
	var dir = (to - position).normalized()
	self.linear_velocity = dir * bullet_speed

func _area_entered(area: Area2D):
	if area.get_parent().is_in_group("Boss"):
		area.get_parent().damage()
		queue_free()

func _ready():
	add_to_group("Bullet")

func _process(_delta):
	if (self.global_position - initial).length() > 10000:
		queue_free()

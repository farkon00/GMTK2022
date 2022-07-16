extends "res://scripts/Bullet.gd"
class_name EnemyBullet

func _body_entered(body: Node2D):
	if body.is_in_group("Player"):
		body.damage()
		queue_free()

func _ready():
	bullet_speed = 400
	add_to_group("Bullet")

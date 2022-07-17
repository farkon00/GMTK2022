extends "BaseBoss.gd"

export var speed: float = 150
export var dash_speed: float = 900

var point = Vector2.ZERO
var initial_distance: float = 0
var speed_mult: float = 1
var waiting_for_point = false

var in_dash = false
var dash_vector = Vector2.ZERO

var bullet: PackedScene = preload("res://EnemyBullet.tscn")

func new_point():
	point = Vector2.ZERO
	point.x = rand_range(0, get_viewport_rect().size.x)
	point.y = rand_range(0, get_viewport_rect().size.y)
	initial_distance = point.distance_to(position)
	waiting_for_point = false

func _attack_area_entered(body):
	if body.is_in_group("Player"):
		body.damage()

func _ready():
	._ready()
	new_point()

func _process(delta):
	if in_dash:
		yield(get_tree().create_timer(0.4), "timeout")
		$"AnimatedSprite".set_animation("dash_" + get_current_side())
		global_position += dash_vector * dash_speed * delta
	elif abs(point.x - position.x) < 30 and abs(point.y - position.y) < 30 and not waiting_for_point and not in_dash:
		$"AnimatedSprite".set_animation(get_current_side())
		waiting_for_point = true
		yield(get_tree().create_timer(0.1), "timeout")

		new_point()
		speed_mult = 1
	elif not waiting_for_point and randi() % 300 == 0:
		in_dash = true
		dash_vector = ($"../Player".global_position - global_position).normalized()
		$"AnimatedSprite".set_animation("dash_" + get_current_side())
		yield(get_tree().create_timer(0.4), "timeout")
		in_dash = false
		new_point()
	else:
		$"AnimatedSprite".set_animation(get_current_side())
		if point.distance_to(position) > initial_distance / 2 and not in_dash:
			speed_mult += 0.03
		else:
			speed_mult -= 0.03
			speed_mult = max(speed_mult, 1)
	position += (point - position).normalized() * speed * speed_mult * delta

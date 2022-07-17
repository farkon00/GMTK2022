extends "BaseBoss.gd"

export var speed = 200
export var vert_speed = 100
export var top_move_speed = 250
export var max_mode_time = 10

# Modes
# 1 - top + beam
# 0 - in attack
# -1 - flying + aura
var mode = 1
var timer = 0

var beam = preload("res://Beam.tscn")
var aura = preload("res://Aura.tscn")

func _attack_body_entered(body):
	if body.is_in_group("Player"):
		body.damage()

func check_side():
	$"AnimatedSprite".set_animation(get_current_side())

func check_mode(delta):
	timer -= delta
	if timer <= 0:
		mode = -mode
		timer = max_mode_time

func check_top_move(delta):
	var dist = global_position.x - $"../Player".global_position.x
	if abs(dist) < 20:
		return
	var move_dir = -sign(dist)
	position.x += move_dir * delta * top_move_speed

func check_beam():
	if global_position.x - $"../Player".global_position.x < 30 and randi() % 75 == 0:
		mode = 0
		yield(get_tree().create_timer(0.7), "timeout")
		var new_beam = beam.instance()
		new_beam.global_position = global_position
		new_beam.get_node("Area2D").connect("body_entered", self, "_attack_body_entered")
		$"..".add_child(new_beam)
		mode = 1 if randi() % 3 == 0 else -1
		yield(get_tree().create_timer(0.7), "timeout")
		new_beam.queue_free()

func check_move(delta):
	$"AnimatedSprite".set_animation(.get_current_side())
	var dist = global_position - $"../Player".global_position
	if abs(dist.x) < 30:
		return
	var move_dir = -sign(dist.x)
	position.x += speed * delta * move_dir

	if abs(dist.y) < 30:
		return
	move_dir = -sign(dist.y)
	position.y += vert_speed * delta * move_dir

func check_aura():
	print(global_position.distance_to($"../Player".global_position))
	if global_position.distance_to($"../Player".global_position) < 130 and randi() % 100 == 0:
		mode = 0
		yield(get_tree().create_timer(0.5), "timeout")
		var new_aura = aura.instance()
		new_aura.global_position = global_position
		new_aura.get_node("Area2D").connect("body_entered", self, "_attack_body_entered")
		$"..".add_child(new_aura)
		mode = -1 if randi() % 3 == 0 else 1
		yield(get_tree().create_timer(0.7), "timeout")
		new_aura.queue_free()

func _ready():
	._ready()
	timer = max_mode_time

func _process(delta):
	check_side()
	check_mode(delta)
	if mode == 1:
		check_top_move(delta)
		check_beam()
	elif mode == -1:
		check_move(delta)
		check_aura()

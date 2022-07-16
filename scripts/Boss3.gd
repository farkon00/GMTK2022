extends "BaseBoss.gd"

export var speed: float = 200
export var tp_time: float = 1
export var tp_cooldown: float = 1

var move_dir = 0
var is_tp = false
var tp_timer: float = 0

func check_move(delta):
	var dist = global_position.x - $"../Player".global_position.x
	if abs(dist) < 30:
		return
	move_dir = -sign(dist)
	position.x += speed * delta * move_dir

func check_tp(delta):
	if tp_timer > 0:
		tp_timer -= delta
		return
	var dist_vec = (global_position - $"../Player".global_position).abs()
	if dist_vec.x > 250 or dist_vec.y > 170:
		is_tp = true
		position.x = 100000000
		var tp_pos = $"../Player".global_position
		yield(get_tree().create_timer(tp_time), "timeout")
		global_position = tp_pos 
		is_tp = false
		tp_timer = tp_cooldown

func _process(delta):
	if is_tp:
		return
	check_move(delta)
	check_tp(delta)

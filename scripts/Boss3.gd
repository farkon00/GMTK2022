extends "BaseBoss.gd"

export var speed: float = 200

var move_dir = 0

func check_move(delta):
	var dist = global_position.x - $"../Player".global_position.x
	if abs(dist) < 30:
		return
	move_dir = -sign(dist)
	position.x += speed * delta * move_dir

func _process(delta):
    check_move(delta)
extends "BaseBoss.gd"

export var speed: float = 200
export var vert_speed: float = 40

var move_dir = 0

func _attack_area_entered(body):
	if body.is_in_group("Player"):
		body.damage()

func check_move(delta):
	$"AnimatedSprite".set_animation(.get_current_side())
	var dist = global_position.x - $"../Player".global_position.x
	if abs(dist) < 30:
		return
	move_dir = -sign(dist)
	position.x += speed * delta * move_dir

func check_vmove(delta):
	var dist = global_position.y - $"../Player".global_position.y
	if abs(dist) < 30:
		return
	move_dir = -sign(dist)
	position.y += vert_speed * delta * move_dir

func check_drop():
	if randi() % 250 == 0:
		var ice_drop = load("res://IceDrop.tscn").instance()
		ice_drop.position.x = $"../Player".global_position.x
		$"..".add_child(ice_drop)

func _process(delta):
	check_move(delta)
	check_vmove(delta)
	check_drop()

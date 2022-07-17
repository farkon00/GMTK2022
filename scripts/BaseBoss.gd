extends KinematicBody2D

export var hp = 15

func get_current_side() -> String:
	var dist = global_position.x - $"../Player".global_position.x
	var move_dir = -sign(dist)
	if move_dir == 1:
		return "right"
	else:
		return "left"

func die():
	$"../Player".start_transition()
	var roller = load("res://DiceRoller.tscn").instance()
	roller.position.y = -600
	$"..".add_child(roller)
	queue_free()

func damage():
	hp -= 1
	if hp <= 0:
		die()

func _ready():
	randomize()
	add_to_group("Boss")

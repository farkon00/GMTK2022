extends KinematicBody2D

export var hp = 5

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

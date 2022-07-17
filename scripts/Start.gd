extends Node2D

func _process(_delta):
	if Input.is_action_pressed("jump"):
		var roller = load("res://DiceRoller.tscn").instance()
		roller.is_starter = true
		$"..".add_child(roller)
		queue_free()

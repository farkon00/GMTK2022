extends Node2D

export var anim_speed = 700
var finished_anim = false
var rolling_back = false

var dices = [
	preload("res://art/dice/1.png"),
	preload("res://art/dice/2.png"),
	preload("res://art/dice/3.png"),
	preload("res://art/dice/4.png"),
	preload("res://art/dice/5.png"),
	preload("res://art/dice/6.png")
]

var locations = [
	preload("res://Locations/1.tscn")
]

var bosses = [
	preload("res://Bosses/boss1.tscn")
]

func roll():
	randomize()
	var dice1 = randi() % 6
	var dice2 = randi() % 6
	$"Dice1".set_texture(dices[dice1])
	$"Dice2".set_texture(dices[dice2])

	return [dice1, dice2]

func _process(delta):
	if rolling_back:
		if position.y > -600:
			queue_free()
		else:
			position.y -= delta * anim_speed
	elif position.y < 0:
		position.y += delta * anim_speed
	elif not finished_anim:
		position.y = 0
		finished_anim = true

		for i in get_tree().get_nodes_in_group("Bullet"):
			i.queue_free()

		yield(get_tree().create_timer(3), "timeout")

		roll()
		$"../TileMap".free()

		yield(get_tree().create_timer(3), "timeout")

		$"..".add_child(locations[0].instance())
		$"..".add_child(bosses[0].instance())
		$"../Player".end_transition()

		rolling_back = true

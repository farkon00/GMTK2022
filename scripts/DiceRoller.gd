extends Node2D

export var anim_speed = 700
var finished_anim = false
var rolling_back = false
var is_starter = false

export var dices = [
	preload("res://art/dice/1.png"),
	preload("res://art/dice/2.png"),
	preload("res://art/dice/3.png"),
	preload("res://art/dice/4.png"),
	preload("res://art/dice/5.png"),
	preload("res://art/dice/6.png")
]

export var locations = [
	preload("res://Locations/1.tscn"),
	preload("res://Locations/2.tscn"),
	preload("res://Locations/3.tscn"),
	preload("res://Locations/4.tscn"),
	preload("res://Locations/5.tscn"),
]

export var bosses = [
	preload("res://Bosses/Boss1.tscn"),
	preload("res://Bosses/Boss2.tscn"),
	preload("res://Bosses/Boss3.tscn"),
	preload("res://Bosses/Boss4.tscn"),
	preload("res://Bosses/Boss5.tscn"),
]

func roll():
	var dice1 = randi() % 6
	var dice2 = randi() % 6
	$"Dice1".set_texture(dices[dice1])
	$"Dice2".set_texture(dices[dice2])

	if 5 in [dice1, dice2]:
		yield(get_tree().create_timer(1), "timeout")
		return roll()

	return [dice1, dice2]

func _ready():
	randomize()
	for i in get_tree().get_nodes_in_group("Bullet"):
		i.queue_free()

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

		yield(get_tree().create_timer(3), "timeout")

		var res = roll()
		if not is_starter:
			$"../TileMap".free()
		else:
			$"/root/Node2D".free()

		yield(get_tree().create_timer(3), "timeout")

		$"..".add_child(locations[res[0]].instance())
		$"..".add_child(bosses[res[1]].instance())
		if not is_starter:
			$"../Player".end_transition()
		else:
			var player = load("res://PLayer.tscn").instance()
			player.start_transition()
			player.end_transition()
			$"..".add_child(player)

		rolling_back = true

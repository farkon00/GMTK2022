extends Node2D

export var anim_speed = 700
var finished_anim = false

var dices = [
	preload("res://art/dice/1.png"),
	preload("res://art/dice/2.png"),
	preload("res://art/dice/3.png"),
	preload("res://art/dice/4.png"),
	preload("res://art/dice/5.png"),
	preload("res://art/dice/6.png")
]

func roll():
	randomize()
	var dice1 = randi() % 6
	var dice2 = randi() % 6
	$"Dice1".set_texture(dices[dice1])
	$"Dice2".set_texture(dices[dice2])


func _process(delta):
	if position.y < 0:
		position.y += delta * anim_speed
	elif not finished_anim:
		position.y = 0
		finished_anim = true
		yield(get_tree().create_timer(3), "timeout")
		roll()

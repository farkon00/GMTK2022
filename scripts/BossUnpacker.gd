extends Node2D

func _ready():
	for i in get_children():
		get_parent().add_child(i)
	free()

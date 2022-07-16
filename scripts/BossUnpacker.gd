extends Node2D

func _ready():
	get_parent().add_child(load("res://Bosses/Boss2Trigger.tscn").instance())
	get_parent().add_child(load("res://Bosses/Boss2Main.tscn").instance())

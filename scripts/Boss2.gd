extends "BaseBoss.gd"

export var speed: float = 120
export var jump_height: float = 300 
export var jump_time: float = 0.4
export var jump_wait: float = 0.08

export var gravity: float = 500
export var gravity_incr: float = 10

var gravity_mult = 1
var on_floor = false
var is_jumping = false
var jump_completed: float = 0
var jump_vel: float = 0
var jump_wait_timer: float = 0

var is_wall = false
var move_dir = 1

var prev_pos: Vector2 = Vector2(0, 0)

var is_shooting = false

var bullet: PackedScene = preload("res://EnemyBullet.tscn")

func _floor_entered(area):
	if area.get_parent().is_in_group("Boss"):
		on_floor = true

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		body.damage()

func get_current_side() -> String:
	var dist = global_position.x - $"../Player".global_position.x
	move_dir = -sign(dist)
	if move_dir == 1:
		return "right"
	else:
		return "left"

func shoot_at_player():
	$"AnimatedSprite".set_animation("mouth_" + get_current_side())
	is_shooting = true
	yield(get_tree().create_timer(0.1), "timeout")
	var bullet_inst = bullet.instance()
	bullet_inst.create(global_position, $"../Player".position)
	bullet_inst.get_node("ColorRect").color = Color(0, 230, 0)
	bullet_inst.bullet_speed = 200
	get_node("/root").add_child(bullet_inst)
	$"AnimatedSprite".set_animation(get_current_side())
	is_shooting = false

func check_gravity(delta):
	if is_jumping:
		return
	if jump_wait_timer > 0:
		jump_wait_timer -= delta
		if jump_wait_timer < 0:
			jump_wait_timer = 0
		return
		
	position.y += (gravity_mult + gravity_incr * delta) * gravity * delta 

func check_jump(delta):
	if is_jumping:
		jump_vel = jump_height/jump_time
		jump_completed += jump_height/jump_time*delta
		if jump_completed > jump_height:
			jump_vel = 0
			is_jumping = false
			jump_wait_timer = jump_wait
		position.y += -jump_vel * delta 

func check_move(delta):
	var dist = global_position.x - $"../Player".global_position.x
	move_dir = -sign(dist)
	if not is_shooting:
		$"AnimatedSprite".set_animation(get_current_side())
	if abs(dist) < 10 and prev_pos == $"../Player".global_position:
		position.x = $"../Player".global_position.x
	else:
		position.x += speed * delta * move_dir
	prev_pos = $"../Player".global_position

func check_shoot():
	if randi() % 300 == 0:
		shoot_at_player()

func _ready():
	randomize()

func _process(delta):
	check_gravity(delta)
	if on_floor:
		jump_completed = 0
		jump_vel = jump_height/jump_time
		on_floor = false
		is_jumping = true
	check_jump(delta)
	check_move(delta)

	check_shoot()

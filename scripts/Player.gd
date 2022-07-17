extends KinematicBody2D

export var jump_height: float = 150
export var jump_time: float = 0.45
export var jump_scaler: Vector3 = Vector3(2, 0.4, 3)
export var jump_wait: float = 0.05

export var min_gravity: float = 210
export var gravity_incr: float = 1.7

export var in_air_move_mult: float = 0.8
export var max_move: float = 450
export var move_incr: float = 4300
export var move_decr: float = 3500
export var start_move_vel: float = 50
export var jump_req_time: float = 0.2

export var shoot_cooldown: float = 0.2

export var hp = 3

export var initial_position = Vector2(500, 100)

var jump_vel: float = 0
var move_vel: float = 0
var jump_completed: float = 0
var jump_wait_timer: float = 0

var left_released: bool = false
var right_released: bool = false
var on_floor: bool = false
var is_jumping: bool = false

var jump_mul: float = jump_scaler[0]
var gravity_mult: float = 1
var jump_req_left: float = 0

var shoot_left: float = 0

var in_transition = false

var bullet: PackedScene = preload("res://Bullet.tscn")

var audio_player = preload("res://AudioPlayer.tscn") 

var jump_sound = preload("res://Sounds/Jump.wav")
var hit_sound = preload("res://Sounds/Hit.wav")
var shoot_sound = preload("res://Sounds/Shoot.wav")
var death_sound = preload("res://Sounds/Death.wav")
var win_sound = preload("res://Sounds/Win.wav")

func play_sound(sound):
	var player = audio_player.instance()
	player.set_stream(sound)
	add_child(player)
	player.play()

func check_move(delta: float) -> void:
	var inputXDir = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	var xDir = sign(move_vel)
	var air_mult: float = 1
	if not on_floor:
		air_mult = in_air_move_mult
	if inputXDir == -1:
		$"AnimatedSprite".set_animation("left_idle")
	elif inputXDir == 1:
		$"AnimatedSprite".set_animation("right_idle")
	if inputXDir != 0:
		if move_vel == 0 or (xDir != sign(inputXDir)):
			move_vel = inputXDir * start_move_vel
		elif move_vel * inputXDir < max_move:
			move_vel = move_vel + (move_incr * delta * inputXDir)
	elif move_vel != 0:
		move_vel = move_vel - (move_decr * delta * xDir)
		if sign(move_vel) != xDir:
			move_vel = 0
	
	var	__ = move_and_collide(Vector2(move_vel * delta * air_mult, 0))

func check_gravity(delta: float) -> void:
	if is_jumping:
		return
	if jump_wait_timer > 0:
		jump_wait_timer -= delta
		return
	var collide = move_and_collide(Vector2(0, (gravity_mult + gravity_incr) * min_gravity * delta)) 
	on_floor = collide != null
	if on_floor:
		on_floor = collide.get_angle() == 0
	if on_floor:
		gravity_mult = 1

func check_jump(delta: float) -> void:
	if Input.is_action_just_pressed("jump") or jump_req_left > 0:
		if on_floor:
			play_sound(jump_sound)
			jump_mul = jump_scaler[0]
			jump_completed = 0
			jump_vel = jump_height/jump_time*jump_mul
			on_floor = false
			is_jumping = true
		elif jump_req_left <= 0:
			jump_req_left = jump_req_time
	if is_jumping:
		jump_vel = jump_height/jump_time*jump_mul
		jump_completed += jump_height/jump_time*jump_mul*delta
		jump_mul -= jump_scaler[2]*delta
		if jump_mul < jump_scaler[1]:
			jump_mul = jump_scaler[1]
		if jump_completed > jump_height:
			jump_vel = 0
			is_jumping = false
			jump_wait_timer = jump_wait
		var coll = move_and_collide(Vector2(0, -jump_vel * delta)) 
		if coll:
			if coll.get_angle() >= 3.1415 && coll.get_angle() <= 3.1416:
				jump_vel = 0
				is_jumping = false

		jump_req_left -= delta
		if jump_req_left < 0:
			jump_req_left = 0

func check_shoot(delta):
	shoot_left -= delta
	if Input.is_action_pressed("shoot") and shoot_left < 0:
		play_sound(shoot_sound)
		shoot_left = shoot_cooldown
		var bullet_inst = bullet.instance()
		bullet_inst.create(self.global_position, get_global_mouse_position())
		get_node("/root").add_child(bullet_inst)

func die():
	play_sound(death_sound)
	$"../Boss".queue_free()
	start_transition()
	var roller = load("res://DiceRoller.tscn").instance()
	roller.position.y = -600
	roller.set_text("Game Over")
	$"..".add_child(roller)

func damage():
	play_sound(hit_sound)
	hp -= 1
	if hp <= 0:
		die()
	$"HP".set_text(str(hp))

func start_transition():
	if hp > 0:
		play_sound(win_sound)
	in_transition = true

func end_transition():
	if hp <= 0:
		hp = 3
		$"HP".set_text(str(hp))
	move_decr = 800 if $"../TileMap".is_in_group("Loc3") else 3500
	in_transition = false
	position = initial_position

func _ready():
	add_to_group("Player")

func _process(delta: float) -> void:
	if not in_transition:
		check_move(delta)
		check_gravity(delta)
		check_jump(delta)
		check_shoot(delta)

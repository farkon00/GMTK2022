extends KinematicBody2D

export var speed: float = 200

var point = Vector2.ZERO
var initial_distance: float = 0
var speed_mult: float = 1
var waiting_for_point = false

func new_point():
    point = Vector2.ZERO
    point.x = rand_range(0, get_viewport_rect().size.x)
    point.y = rand_range(0, get_viewport_rect().size.y)
    initial_distance = point.distance_to(position)
    print(point)
    waiting_for_point = false

func _ready():
    randomize()
    new_point()

func _process(delta):
    if abs(point.x - position.x) < 30 and abs(point.y - position.y) < 30 and not waiting_for_point:
        waiting_for_point = true
        yield(get_tree().create_timer(0.2), "timeout")
        new_point()
        speed_mult = 1
    else:
        if point.distance_to(position) > initial_distance / 2:
            speed_mult += 0.03
        else:
            speed_mult -= 0.03
            speed_mult = max(speed_mult, 1)
    position += (point - position).normalized() * speed * speed_mult * delta
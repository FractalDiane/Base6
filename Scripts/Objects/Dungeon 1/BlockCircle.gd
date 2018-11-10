extends KinematicBody2D

export(int) var radius = 0
export(float) var speed = 1
export(float) var delay = 0

var t = 0
var add = 0
onready var startpos = get_position()

var move = false

func _ready():
	if delay > 0:
		$TimerDelay.set_wait_time(delay)
		$TimerDelay.start()
	else:
		move = true

func _physics_process(delta):
	if move:
		t += speed
		var angle = deg2rad(t)

		var add_x = radius * cos(angle)
		var add_y = radius * sin(angle)

		set_position(startpos + Vector2(add_x, add_y))
		
func _on_TimerDelay_timeout():
	move = true
		
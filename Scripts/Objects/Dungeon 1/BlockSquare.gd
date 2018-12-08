extends RigidBody2D

export(float) var delay = 0
export(float) var speed = 0
export(float) var interval_h = 1
export(float) var interval_v = 1

export(int) var dir_x = 1
export(int) var dir_y = 1

var move = false

func _ready():
	if delay > 0:
		$TimerDelay.set_wait_time(delay)
		$TimerDelay.start()
	else:
		move = true

var t = 0.0
var add = 0
onready var startpos = get_position()

func _physics_process(delta):
	set_z_index(get_position().y)
	if move:
		t += controller.convert_to_seconds(1, delta)
		
		if dir_x != 0 and dir_y == 0:
			if t > interval_h * 60:
				t = 0
				change_direction()
		elif dir_y != 0 and dir_x == 0:
			if t > interval_v * 60:
				t = 0
				change_direction()

		set_position(get_position() + (speed * delta * Vector2(dir_x, dir_y)))
		
func change_direction():
	match(Vector2(dir_x, dir_y)):
		Vector2(0,1):
			dir_x = 1
			dir_y = 0
		Vector2(1,0):
			dir_x = 0
			dir_y = -1
		Vector2(0,-1):
			dir_x = -1
			dir_y = 0
		Vector2(-1,0):
			dir_x = 0
			dir_y = 1
	t = 0
	
func _on_TimerDelay_timeout():
	move = true

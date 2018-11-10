extends RigidBody2D

export(float) var delay = 0
export(float) var speed = 0
export(float) var interval = 1
export(bool) var vertical = false

export(int) var dir_x = 1
export(int) var dir_y = 1

var move = false

func _ready():
	if delay > 0:
		$TimerDelay.set_wait_time(delay)
		$TimerDelay.start()
	else:
		move = true

var t = 0
var add = 0
onready var startpos = get_position()

func _physics_process(delta):
	if move:
		t += 1
		
		
		if t % int(interval * 60) == 0:
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
		#add = controller.wave(-move_range, move_range, time, 0, t, delta)
		
		var add_vector
		if vertical:
			add_vector = Vector2(0, add)
		else:
			add_vector = Vector2(add, 0)
		
		#set_linear_velocity(speed * Vector2(dir_x, dir_y))
		set_position(get_position() + (speed * delta * Vector2(dir_x, dir_y)))
	
func _on_TimerDelay_timeout():
	move = true

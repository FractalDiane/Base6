extends KinematicBody2D

export(int) var move_range = 0
export(float) var time = 2
export(float) var delay = 0
export(bool) var vertical = false

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
		add = controller.wave(-move_range, move_range, time, 0, t, delta)
		
		var add_vector
		if vertical:
			add_vector = Vector2(0, add)
		else:
			add_vector = Vector2(add, 0)
		set_position(startpos + add_vector)
	
func _on_TimerDelay_timeout():
	move = true

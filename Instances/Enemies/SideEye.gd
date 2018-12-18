extends AnimatedSprite

var timer

func _ready():
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.set_wait_time(5)
	timer.set_one_shot(true)
	play("up")

func _on_animation_finished():
	if animation == "up":
		timer.start()
	else:
		get_parent().remove_child(self)

func _on_timer_timeout():
	play("down")
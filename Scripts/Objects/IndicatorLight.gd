extends AnimatedSprite

export(String) var target_flag

func _ready():
	if controller.flag[target_flag] == 1:
		set_animation("on")
	else:
		set_animation("off")
		
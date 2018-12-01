extends AnimatedSprite

onready var cont = controller

func _process(delta):
	set_frame(cont.flag["holding_bow"])

extends AnimatedSprite

onready var cont = controller

func _process(delta):
	set_frame(cont.player_item_1)

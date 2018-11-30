extends TextureProgress

onready var cont = controller

func _process(delta):
	set_value(10 - cont.player_corruption)

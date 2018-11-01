extends TextureProgress

onready var cont = controller

func _process(delta):
	set_value(cont.player_health)

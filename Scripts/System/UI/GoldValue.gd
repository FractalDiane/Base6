extends Label

onready var cont = controller

func _process(delta):
	text = str(cont.player_gold).pad_zeros(3)
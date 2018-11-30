extends AnimatedSprite

onready var label = $Label
onready var cont = controller

func _physics_process(delta):
	label.set_text(str(cont.player_potions))

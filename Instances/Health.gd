extends TextureProgress

onready var cont = controller

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	set_value(cont.player_health)

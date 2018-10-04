extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	# Manage UI sprites
	$SpriteHealth.set_frame(get_node("/root/controller").player_health)
	$SpriteCorruption.set_frame(get_node("/root/controller").player_corruption)
	
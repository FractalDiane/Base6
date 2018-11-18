extends TileMap

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	hide()
	get_tree().get_root().get_node("Node2D").get_node("PitController").get_node("Bridge").set_disabled(true)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

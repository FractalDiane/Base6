extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	if controller.flag["holding_dungeon1key"] == 1:
		$Sprite.set_animation("open")
		$CollisionShape2D.set_disabled(true)
		get_tree().get_root().get_node("Node2D").get_node("NPCKein").queue_free()
	else:
		$Transition.queue_free()
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#func _ready():
#	# Called when the node is added to the scene for the first time.
#	# Initialization here
#	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Timer_timeout():
	controller.scene_change("res://Scenes/GATE/Gate-4.tscn")
	Player.set_position(Vector2(80,20))
	Player.get_node("Sprite").play("down")
	Player.get_node("TimerBadEnding").start()
	Player.show()
	
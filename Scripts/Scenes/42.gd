extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	if controller.holding_thekey:
		if controller.flag["dungeon2_complete"] == 1:
			$NPCDoor.queue_free()
		else:
			$NPCDoor.dialogue_set = 1
			$TransitionDoor.queue_free()
	else:
		$TransitionDoor.queue_free()
	
	if controller.holding_theitem or controller.bad_ending:
		$NPCDoor.queue_free()
		$TransitionDoor.queue_free()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

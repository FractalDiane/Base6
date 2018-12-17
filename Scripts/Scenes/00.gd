extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	if controller.flag["dungeon1_complete"] == 0:
		$NPCJariD1.queue_free()
		
	if controller.flag["dungeon2_complete"] == 0:
		$NPCIiro00.queue_free()
		$NPCJariD2.queue_free()
		$NPCKein00.queue_free()
		$NPCAzura00.queue_free()
	else:
		$NPCJariD1.queue_free()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

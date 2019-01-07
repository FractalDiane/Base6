extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	if controller.bad_ending:
		$Transition2.queue_free()
	else:
		$Walls/CollisionShape2D.queue_free()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

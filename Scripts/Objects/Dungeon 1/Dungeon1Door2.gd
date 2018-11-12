extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	if controller.flag["dungeon1_switches2TL"] == 1 and controller.flag["dungeon1_switches2BL"] == 1 and controller.flag["dungeon1_switches2TR"] == 1 and controller.flag["dungeon1_switches2BR"] == 1:
		$Sprite.set_animation("open")
		$CollisionShape2D.set_disabled(true)
		$IndicatorLight.queue_free()
		$IndicatorLight2.queue_free()
		$IndicatorLight3.queue_free()
		$IndicatorLight4.queue_free()
	else:
		$Transition.queue_free()
		
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

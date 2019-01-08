extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_TimerGlitch_timeout():
	controller.player_corruption = 0
	audioplayer.hum.stop()
	if controller.holding_thekey:
		Player.fully_corrupted = false
		controller.reset_checkpoint()
		controller.scene_change("res://Scenes/Title.tscn", false)
	else:
		controller.scene_change("res://Scenes/Corrupted3.tscn", false)

extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _on_TimerCorrupt_timeout():
	controller.player_corrupt(1)
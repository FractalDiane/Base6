extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _physics_process(delta):
	Player.state = Player.NO_INPUT
	Player.motion = Vector2(0,0)


func _on_TimerSwitch_timeout():
	Player.hide()
	controller.scene_change("res://Scenes/GameOver.tscn")

extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _physics_process(delta):
	Player.state = Player.NO_INPUT
	Player.motion = Vector2(0,0)
	controller.player_corruption = 0
	audioplayer.hum.stop()
	
	if Player.face == Vector2(0,-1):
		Player.get_node("Sprite").play("up")
	elif Player.face == Vector2(0,1):
		Player.get_node("Sprite").play("down")
	elif Player.face == Vector2(-1,0):
		Player.get_node("Sprite").play("left")
	elif Player.face == Vector2(1,0):
		Player.get_node("Sprite").play("right")

func _on_TimerSwitch_timeout():
	Player.hide()
	controller.scene_change("res://Scenes/GameOver.tscn")

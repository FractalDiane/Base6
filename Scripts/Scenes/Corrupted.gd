extends Node2D

var die = false

func _ready():
	$TimerSoundEffect.start()
	$TimerParts.start()
	$TimerDarkness.start()
	
func _physics_process(delta):
	Player.state = Player.NO_INPUT
	Player.motion = Vector2(0,0)
	
	if die:
		if Player.face == Vector2(0,-1):
			Player.get_node("Sprite").play("dieup")
		elif Player.face == Vector2(0,1):
			Player.get_node("Sprite").play("diedown")
		elif Player.face == Vector2(-1,0):
			Player.get_node("Sprite").play("dieleft")
		elif Player.face == Vector2(1,0):
			Player.get_node("Sprite").play("dieright")
	else:
		if Player.face == Vector2(0,-1):
			Player.get_node("Sprite").play("up")
		elif Player.face == Vector2(0,1):
			Player.get_node("Sprite").play("down")
		elif Player.face == Vector2(-1,0):
			Player.get_node("Sprite").play("left")
		elif Player.face == Vector2(1,0):
			Player.get_node("Sprite").play("right")

func _on_TimerSoundEffect_timeout():
	$SoundCORRUPTED.play(0)

func _on_TimerParts_timeout():
	$GLITCHLAYER/PartsGLITCH.set_emitting(true)
	$GLITCHLAYER/PartsGLITCH/GLITCH.show()
	controller.player_corruption = 100
	audioplayer.hum.stop()

func _on_TimerDarkness_timeout():
	$SoundCORRUPTED.stop()
	Player.hide()
	controller.scene_change("res://Scenes/Corrupted2.tscn")

func _on_Timer_timeout():
	die = true

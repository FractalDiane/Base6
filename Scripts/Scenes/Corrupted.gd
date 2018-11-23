extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$TimerSoundEffect.start()
	$TimerParts.start()
	$TimerDarkness.start()
	
func _physics_process(delta):
	Player.state = Player.NO_INPUT

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
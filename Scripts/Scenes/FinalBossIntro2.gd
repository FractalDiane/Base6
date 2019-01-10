extends StaticBody2D

var text_2 = ["We share the same fate.", "A fate of endless life and death.",
				"A fate we hold no authority to challenge.", "For we are not perfect."]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	Player.state = Player.NO_INPUT
	Player.motion = Vector2(0,0)
	Player.face = Vector2(0,-1)
	Player.get_node("Sprite").play("up")

func _on_TimerDialogue_timeout():
	if controller.finalboss_init:
		get_node("TimerStartBoss").start()
		audioplayer.get_node("MusicFinalBoss").play(0)
		audioplayer.current_music = audioplayer.get_node("MusicFinalBoss").stream
	else:
		controller.dialogue_registry(text_2, self, 15, 10, 100, 50, false)

func _on_TimerStartBoss_timeout():
	controller.finalboss_init = true
	controller.scene_change("res://Scenes/GATE/CorrBoss.tscn")
	Player.show()

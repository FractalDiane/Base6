extends StaticBody2D

var text_2 = ["Stop.", "What do you believe you will achieve by destroying us?", "A resolution? An end to this cycle?",
				"You have never understood.", "We are merely a cog in the machine.", "We are not the puppeteer pulling the strings.",
				"You are the puppeteer.", "Your existence keeps them trapped.", "Your journey is their suffering.", "Your victory is their damnation.",
				"There is no one to blame but yourself...", "Fiore."]

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
	controller.dialogue_registry(text_2, self, 15, 10, 100, 50, false)

func _on_TimerStartBoss_timeout():
	controller.scene_change("res://Scenes/GATE/CorrBoss.tscn")
	Player.show()

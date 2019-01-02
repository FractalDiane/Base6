extends StaticBody2D

var text = ["Are you satisfied with your decision?", "You have destroyed us forever.", "Unfortunately, forever means nothing.",
				"We will return.", "They will return.", "You will die.", "You will return.", "The world", "will die",
				"and", "the", "world", "will", "return."]

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
	controller.dialogue_registry(text, self, 15, 10, 100, 50, false)

func _on_TimerRoomChange_timeout():
	controller.scene_change("res://Scenes/GATE/Gate-BadEnd3.tscn", false)

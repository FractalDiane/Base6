extends StaticBody2D

var text = ["We may finally rest", "if only for a while."]

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

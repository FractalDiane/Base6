extends StaticBody2D

var text_a = ["We hold no control over your actions.", "Destroy us.", "Complete your mission.",
				"But do so knowing your worthless actions will have accomplished nothing."]

var text_b = ["You are responsible for this fate.", "For as long as you exist", "we exist", "they exist",
				"the world exists", "the world dies", "the world returns", "and they suffer.", "...", "But, perhaps..."]
				
var use_text = []

func _ready():
	if controller.holding_theitem:
		use_text = text_b
	else:
		use_text = text_a

#func _physics_process(delta):
#	Player.state = Player.NO_INPUT
#	Player.motion = Vector2(0,0)
#	Player.face = Vector2(0,-1)
#	Player.get_node("Sprite").play("up")

func _on_TimerDialogue_timeout():
	controller.dialogue_registry(use_text, self, 15, 10, 100, 50, false)

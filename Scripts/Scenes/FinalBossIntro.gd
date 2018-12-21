extends Area2D

var text_1 = ["What do you call yourself?", "A hero? A savior?", "You have never understood.",
				"Your friends wish for us to be whole again.", "They have never understood.",
				"The cultists wish for us to die.", "They have never understood.", "We were born not of ill intent",
				"but of desire.", "We exist for the most menial of purposes.", "But we are not perfect.", "We are broken."]
				
var active = false

onready var player = Player

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func _physics_process(delta):
	if active:
		Player.state = Player.NO_INPUT
		Player.motion = Vector2(0,0)
		Player.face = Vector2(0,-1)
		Player.get_node("Sprite").play("up")

func _on_EntryTrigger_body_entered(body):
	if not active:
		player.state = player.NO_INPUT
		$TimerMusic.start()
		$TimerDialogue.start()
		active = true

func _on_TimerMusic_timeout():
	$MusicConfrontation.play(0)

func _on_TimerDialogue_timeout():
	controller.dialogue_registry(text_1, self, 15, 10, 100, 50, false)

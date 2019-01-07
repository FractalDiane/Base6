extends Node2D

var text = ["You hold the key.", "You now understand.", "You understand", "what must be done.", "What will end this cycle.",
			"Just as you are the key to their suffering", "you are the key to the resolution."]

var lock = true

onready var player = Player

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	if lock:
		player.state = Player.NO_INPUT
		player.motion = Vector2(0,0)
		player.face = Vector2(0,-1)
		player.get_node("Sprite").play("up")

func _on_TimerDialogue_timeout():
	lock = false
	#player.state = player.WALK
	controller.dialogue_registry(text, self, 15, 10, 100, 50, false, true, true)

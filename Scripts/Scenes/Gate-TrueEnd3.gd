extends Node2D

var text = ["This will be your final act.", "The end of your existence", "forever.", "The end of the cycle.",
				"Their salvation.", "Our salvation."]

var lock = true
var in_area = false

onready var player = Player

func _ready():
	player.get_node("Sprite").play("up")

func _physics_process(delta):
	if lock:
		player.state = Player.NO_INPUT
		player.motion = Vector2(0,0)
		player.face = Vector2(0,-1)
		if not in_area:
			Player.get_node("Sprite").play("up")

func _on_TimerDialogue_timeout():
	controller.dialogue_registry(text, self, 15, 10, 100, 50, false, true, true)

func _on_EndArea_body_entered(body):
	if body == player and not lock and not in_area:
		lock = true
		Player.get_node("Sprite").play("up")
		in_area = true
		$TimerTurnDown.start()

func _on_TimerTurnDown_timeout():
	Player.get_node("Sprite").play("down")
	$TimerHoldUp.start()

func _on_TimerHoldUp_timeout():
	$SoundHoldUp.play(0)
	Player.get_node("Sprite").play("ending")
	$TheItem.set_position(Vector2(Player.get_position().x, Player.get_position().y - 20))
	$TheItem.show()
	$TimerCorruption.start()

func _on_TimerCorruption_timeout():
	$SoundStatic.play(0)
	get_node("GLITCHLAYER").get_node("PartsGLITCH").set_emitting(true)
	get_node("GLITCHLAYER").get_node("PartsGLITCH").get_node("GLITCH").show()
	$TimerGlitch.start()

func _on_TimerGlitch_timeout():
	pass # replace with function body

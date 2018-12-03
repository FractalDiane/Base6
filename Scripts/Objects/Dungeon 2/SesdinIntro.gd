extends KinematicBody2D

var dialogue_text = ["Hello, Fiore.", "I thought you'd never show up.", "The acolytes have told me a lot about you.",
					"My name is Sesdin. I'm the leader of our coalition.", "For years, we've wanted to escape from this forsaken gray land.",
					"The corruption seeping into the land is that very escape.", "It will release us from this eternal prison.",
					"But you want to destroy it.", "That I won't allow.", "You do not understand what you're doing.",
					"You think yourself a hero.", "But you've done naught but perpetuate the cycle.", "You are the harbinger of damnation.",
					"Fiore!", "You have something I want.", "The keystone pieces.", "I've already taken one from this ruin, but I need the others.",
					"I know you won't give them to me.", "So I'll pluck them from your corpse instead."]

var active = false
var boss_start = false

onready var player = Player
onready var trigger = $EnterTrigger
onready var boss_obj = get_tree().get_root().get_node("Node2D").get_node("SesdinBoss")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func _physics_process(delta):
	if not boss_start:
		Player.state = Player.NO_INPUT
		Player.motion = Vector2(0,0)
		Player.face = Vector2(0,-1)
		Player.get_node("Sprite").play("up")
	var coll = trigger.get_overlapping_bodies()
	if player in coll and not active:
		$TimerShutDoor.start()
		$TimerIntro.start()
		active = true
	
func intro():
	$Sprite.play("down")
	controller.dialogue(dialogue_text, self, 10, 10, 140, 45)

func teleport():
	$SoundTeleport.play(0)
	$PartsTeleport.set_emitting(true)
	$Sprite.hide()
	
func _on_TimerShutDoor_timeout():
	$SoundDoorShut.play(0)
	$Door.show()
	$DoorHB.set_disabled(false)

func _on_TimerIntro_timeout():
	Player.state = Player.NO_INPUT
	Player.motion = Vector2(0,0)
	Player.face = Vector2(0,-1)
	intro()

func _on_TimerTeleport_timeout():
	teleport()
	$TimerStartBoss.start()

func _on_TimerStartBoss_timeout():
	$MusicBoss.play(0)
	boss_start = true
	Player.state = Player.WALK
	$EnterTrigger/CollisionShape2D.set_disabled(true)
	boss_obj.active = true
	boss_obj.get_node("TimerTP").start()
	$CollisionShape2D.set_disabled(true)

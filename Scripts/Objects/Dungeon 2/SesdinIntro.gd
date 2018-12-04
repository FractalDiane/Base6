extends KinematicBody2D

var dialogue_text = ["Hello, Fiore.", "I thought you'd never show up.", "The acolytes have told me a lot about you.",
					"My name is Sesdin. I'm the leader of our coalition.", "For years, we've wanted to escape from this forsaken gray land.",
					"The corruption seeping into the land is that very escape.", "It will release us from this eternal prison.",
					"But you want to destroy it.", "That I won't allow.", "You do not understand what you're doing.",
					"You think yourself a hero.", "But you've done naught but perpetuate the cycle.", "You are the harbinger of damnation.",
					"Fiore!", "You have something I want.", "The keystone pieces.", "I've already taken one from this ruin, but I need the others.",
					"I know you won't give them to me.", "So I'll pluck them from your corpse instead."]
					
var dialogue_text_end = ["You are a skilled warrior.", "Truly, you are the harbinger of damnation.", "I suppose we cannot stop the doom that you herald.",
						"I hope you are happy with your decision...", "Fiore."]

var active = false
var boss_start = false
var after = false
var end = false
var finished = false

onready var player = Player
onready var trigger = $EnterTrigger
onready var boss_obj = get_tree().get_root().get_node("Node2D").get_node("SesdinBoss")

func _ready():
	$Transition/CollisionShape2D.set_disabled(true)
	
func _physics_process(delta):
	if not finished:
		if not boss_start or after:
			Player.state = Player.NO_INPUT
			Player.motion = Vector2(0,0)
			Player.face = Vector2(0,-1)
			Player.get_node("Sprite").play("up")
	var coll = trigger.get_overlapping_bodies()
	if player in coll and not active:
		$TimerShutDoor.start()
		$TimerIntro.start()
		active = true
		
	if not end:
		if controller.flag["holding_gatekey"] == 1:
			$SoundDoorShut.play(0)
			$Door.hide()
			$DoorHB.set_disabled(true)
			controller.flag["dungeon2_complete"] = 1
			controller.player_corruption = 0
			audioplayer.hum.stop()
			controller.corrupted_cells_add += ["01","02","03","?1","10","11","20","21","22","30","31","40","41","42","?2"]
			$Transition/CollisionShape2D.set_disabled(false)
			end = true
	
func intro():
	$Sprite.play("down")
	controller.dialogue(dialogue_text, self, 10, 10, 140, 45)

func teleport():
	$SoundTeleport.play(0)
	$PartsTeleport.set_emitting(true)
	$Sprite.hide()
	
func end_dialogue():
	controller.dialogue(dialogue_text_end, self, 10, 10, 140, 45)
	
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

func _on_TimerEndDialogue_timeout():
	end_dialogue()

func _on_TimerEndBoss_timeout():
	$SoundTeleport.play(0)
	$PartsTeleport.set_emitting(true)
	$Sprite.hide()
	$CollisionShape2D.set_disabled(true)
	finished = true
	Player.get_node("SoundPotion").play(0)
	Player.get_node("PartsPotion").set_emitting(true)
	controller.player_health = 10
	get_tree().get_root().get_node("Node2D").get_node("ItemKeystonePiece3").enable = true
	Player.state = Player.WALK
	
	

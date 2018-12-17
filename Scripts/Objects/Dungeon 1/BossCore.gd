extends StaticBody2D

var dead = false
var fast = false
var orbit = false
var health = 2
var leftActive = true
var torso_tex0 = preload("res://Sprites/Characters/Temple Guardians/Torso0.png")
var torso_tex1 = preload("res://Sprites/Characters/Temple Guardians/Torso1.png")
var torso_tex2 = preload("res://Sprites/Characters/Temple Guardians/Torso2.png")
var timer
var shake = false
var shake_amount = 0
var shake_vector = Vector2(0, 0)

var dialogue_text = ["You have proven yourself.", "Take this keystone piece.", "Purge the land of this evil."]

onready var room = get_tree().get_root().get_node("Node2D")
onready var roomLocation = room.position
onready var switchLocation = $OrbSwitch.position
onready var switches = [$Switch1, $Switch2, $Switch3, $Switch4]
onready var player = Player

func _ready():
	$OrbSwitch.translate(Vector2(0, -100))
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.set_wait_time(1)
	timer.set_one_shot(true)

func _on_timer_timeout():
	$Sprite.set_texture(torso_tex0)
	$OrbSwitch.pressed = false

func _physics_process(delta):
	if shake:
		if shake_amount <= 0:
			shake = false
			return
		var temp_vector = Vector2(floor(rand_range(-shake_amount, shake_amount)), floor(rand_range(-shake_amount, shake_amount)))
		var shake_difference = temp_vector - shake_vector
		room.position += shake_difference
		player.position += shake_difference
		shake_vector = temp_vector
		shake_amount -= .05
		
	if controller.flag["holding_bow"] == 1 and controller.flag["holding_dungeon2key"] == 1 and controller.flag["dungeon1_complete"] == 0:
		$EnterTrigger/SoundDoorClose.play(0)
		$EnterTrigger.togglePath()
		controller.flag["dungeon1_complete"] = 1
		controller.corrupted_cells_add += ["04","12","13","32", "43"]

func activate():
	$LeftFist.activate()

func switch():
	leftActive = !leftActive
	if leftActive:
		$LeftFist.activate()
	else:
		$RightFist.activate()

func torsoHit():
	if not orbit:
		$SoundHit.play(0)
	for i in range(switches.size()):
		switches[i].deactivate()
	$OrbSwitch.position = switchLocation - Vector2(0, 100)
	$Sprite.set_texture(torso_tex2)
	timer.start()
	if orbit:
		$LeftFist.deactivate()
		$RightFist.deactivate()
		Player.state = Player.NO_INPUT
		Player.motion = Vector2(0,0)
		Player.jumping = false
		Player.falling = false
		#$EnterTrigger.togglePath()
		$SoundDie.play(0)
		$MusicBoss.stop()
		$TimerShatter.start()
		return
	elif not fast:
		$LeftFist.phase2 = true
		$RightFist.phase2 = true
		fast = true
	else:
		$LeftFist.phase3 = true
		$RightFist.phase3 = true
		orbit = true
	shake = true
	shake_amount = 5

func checkSwitches():
	var flag = true
	for i in range(switches.size()):
		if not switches[i].active:
			flag = false
	if flag:
		$Sprite.set_texture(torso_tex1)
		$OrbSwitch.position = switchLocation

func _on_TimerShatter_timeout():
	$LeftFist.shatter()
	$RightFist.shatter()
	$TimerDialogue.start()

func _on_TimerDialogue_timeout():
	controller.dialogue(dialogue_text, self, 40, 70, 100, 50)

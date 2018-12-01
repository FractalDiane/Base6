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

onready var room = get_tree().get_root().get_node("Node2D")
onready var roomLocation = room.position
onready var switchLocation = $OrbSwitch.position
onready var switches = [$Switch1, $Switch2, $Switch3, $Switch4]

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

func _process(delta):
	if shake:
		if shake_amount <= 0:
			shake = false
			return
		var shake_vector = Vector2(floor(rand_range(-shake_amount, shake_amount)), floor(rand_range(-shake_amount, shake_amount)))
		shake_amount -= .04
		room.position = roomLocation + shake_vector

func activate():
	$LeftFist.activate()

func switch():
	leftActive = !leftActive
	if leftActive:
		$LeftFist.activate()
	else:
		$RightFist.activate()

func torsoHit():
	for i in range(switches.size()):
		switches[i].deactivate()
	$OrbSwitch.position = switchLocation - Vector2(0, 100)
	$Sprite.set_texture(torso_tex2)
	timer.start()
	if orbit:
		$LeftFist.deactivate()
		$RightFist.deactivate()
		$EnterTrigger.togglePath()
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

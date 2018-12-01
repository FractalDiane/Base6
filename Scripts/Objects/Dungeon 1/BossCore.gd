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
	shake = false
	for i in range(switches.size()):
		switches[i].deactivate()

func activate():
	$LeftFist.activate()

func switch():
	leftActive = !leftActive
	if leftActive:
		$LeftFist.activate()
	else:
		$RightFist.activate()

func torsoHit():
	$OrbSwitch.translate(Vector2(0, -100))
	$Sprite.set_texture(torso_tex2)
	timer.start()
	if not fast:
		$LeftFist.speedup = true
		$RightFist.speedup = true
		fast = true
		return
	if not orbit:
		orbit = true
	#get_tree().get_root().get_node("Node2D")

func checkSwitches():
	var flag = true
	for i in range(switches.size()):
		if not switches[i].active:
			flag = false
	if flag:
		$Sprite.set_texture(torso_tex1)
		$OrbSwitch.translate(Vector2(0, 100))
		$OrbSwitch.pressed = false
		shake = true

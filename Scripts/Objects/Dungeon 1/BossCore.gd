extends StaticBody2D

var dead = false
var fast = false
var health = 2
var leftActive = true
var torso_tex1 = preload("res://Sprites/Characters/Temple Guardians/Torso0.png")
var torso_tex2 = preload("res://Sprites/Characters/Temple Guardians/Torso1.png")
var torso_orb = preload("res://Instances/Objects/TorsoOrb.tscn")
var orb

onready var switches = [$Switch1, $Switch2, $Switch3, $Switch4]

func _ready():
	pass

func activate():
	$LeftFist.activate()

func switch():
	leftActive = !leftActive
	if leftActive:
		$LeftFist.activate()
	else:
		$RightFist.activate()

func checkSwitches():
	var flag = true
	for i in range(switches.size):
		if not switches[i].active:
			flag = false
	if flag:
		$Sprite.set_texture(torso_tex2)
		orb = torso_orb.instance()
		add_child(orb)
	else:
		$Sprite.set_texture(torso_tex1)
		remove_child(orb)
	
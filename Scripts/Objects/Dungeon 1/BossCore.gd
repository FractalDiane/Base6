extends StaticBody2D

var dead = false
var fast = false
var health = 2
var leftActive = true

onready var switches = [$Switch1]

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
#func _process(delta):


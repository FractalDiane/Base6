extends StaticBody2D

var dead = false
var fast = false
var health = 2
var leftActive = true

func _ready():
	$LeftFist.activate()

func switch():
	leftActive = !leftActive
	if leftActive:
		$LeftFist.activate()
	else:
		$RightFist.activate()
#func _process(delta):


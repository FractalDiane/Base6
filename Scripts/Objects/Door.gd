extends StaticBody2D

var opened = false

func _ready():
	$Transition/CollisionShape2D.set_disabled(true)
	
func _physics_process(delta):
	if not opened and controller.flag["dungeon2_door1"] == 1:
		open()
		opened = true

func open():
	$Transition/CollisionShape2D.set_disabled(false)
	$Sprite.set_animation("open")
	$CollisionShape2D.set_disabled(true)
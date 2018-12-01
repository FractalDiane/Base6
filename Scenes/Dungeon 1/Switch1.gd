extends Area2D

var active = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func activate():
	active = true
	$Sprite.play("down")
	get_parent().checkSwitches()
	
func deactivate():
	active = false
	$Sprite.play("up")
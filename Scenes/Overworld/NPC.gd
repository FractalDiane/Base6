extends KinematicBody2D

export(Array, Array, String) var text # Dialogue text
export(String) var dialogue_key # Flag key that keeps track of this NPC's dialogue status

export(int) var box_x
export(int) var box_y
export(int) var box_width
export(int) var box_height

var text_page = 0

var show_interact = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	set_z_index(get_position().y)
	
	if show_interact and Player.state == Player.WALK:
		$Interact.show()
		interaction()
	else:
		$Interact.hide()
		
func interaction():
	if Input.is_action_just_pressed("ui_accept"):
		change_direction()
		controller.dialogue(text[text_page],self,box_x,box_y,box_width,box_height)

func change_direction():
	if Player.get_node("Sprite").get_animation() in ["up", "walkup"]:
		$Sprite.set_animation("down")
	elif Player.get_node("Sprite").get_animation() in ["down", "walkdown"]:
		$Sprite.set_animation("up")
	elif Player.get_node("Sprite").get_animation() in ["left", "walkleft"]:
		$Sprite.set_animation("right")
	elif Player.get_node("Sprite").get_animation() in ["right", "walkright"]:
		$Sprite.set_animation("left")
		
func _on_TimerHideInteract_timeout():
	show_interact = false

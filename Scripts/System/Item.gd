extends StaticBody2D

export(Array, String) var item_get_message
export(String) var collect_flag
export(bool) var start_enabled = true

export(int) var box_x
export(int) var box_y
export(int) var box_width
export(int) var box_height

var enable = true

var show_interact = false

onready var interact = $Interact
onready var collision = $CollisionShape2D

func _ready():
	enable = start_enabled
	
	if controller.flag[collect_flag] == 1:
		remove()
	
func _physics_process(delta):
	#set_z_index(get_position().y)
	if enable:
		show()
		collision.set_disabled(false)
	else:
		hide()
		collision.set_disabled(true)
	if show_interact and Player.state == Player.WALK and enable:
		if not interact.is_visible():
			interact.set_frame(1)
		interact.show()
		interaction()
	else:
		interact.hide()
		
func interaction():
	if Input.is_action_just_pressed("ui_accept"):
		if Player.face == Vector2(0,-1):
			Player.get_node("Sprite").play("up")
		elif Player.face == Vector2(0,1):
			Player.get_node("Sprite").play("down")
		elif Player.face == Vector2(-1,0):
			Player.get_node("Sprite").play("left")
		elif Player.face == Vector2(1,0):
			Player.get_node("Sprite").play("right")
		Player.motion = Vector2(0,0)
		$SoundItemGet.play(0)
		controller.flag[collect_flag] = 1
		controller.dialogue(item_get_message,self,box_x,box_y,box_width,box_height)
		remove()
			
func remove():
	$Sprite.hide()
	$CollisionShape2D.set_disabled(true)
	enable = false

func _on_TimerHideInteract_timeout():
	show_interact = false

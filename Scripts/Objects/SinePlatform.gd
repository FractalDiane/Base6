extends KinematicBody2D

export(int) var move_range = 32
export(float) var time = 2
export(bool) var vertical = false

var colliding = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

var t = 0
var add = 0
onready var startpos = get_position()
onready var player = Player
onready var area = $Area2D

func _physics_process(delta):
	#set_z_index(get_position().y)
	t += 1
	add = controller.wave(-move_range, move_range, time, 0, t, delta)
	
	var add_vector
	if vertical:
		add_vector = Vector2(0, add)
	else:
		add_vector = Vector2(add, 0)
	#set_position(startpos + add_vector)
	
	print(get_floor_velocity())
	
	move_and_slide(add_vector)
	
	if get_slide_count() > 0:
		colliding = true
	else:
		colliding = false
	

	
	#if player in area.get_overlapping_bodies():
		#player.motion.x += add
	

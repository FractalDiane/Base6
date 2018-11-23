extends CollisionPolygon2D

var angle = 90
var target_angle = 90
var radius = 24

onready var pos_x = get_position().x
onready var pos_y = get_position().y
onready var player = Player
onready var area = $Area2D

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	angle = clamp(angle - 2, target_angle, target_angle + 90)
	#angle -= 1
	var angle_rad = deg2rad(angle)
	pos_x = (radius * 2) * cos(angle_rad) + 36
	pos_y = radius * sin(angle_rad)
	set_position(Vector2(pos_x, pos_y))
	
	#if player in area.get_overlapping_bodies():
		#player.motion = 

func shift():
	target_angle -= 90
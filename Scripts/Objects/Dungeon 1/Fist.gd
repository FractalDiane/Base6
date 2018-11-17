extends KinematicBody2D

var active = false
var following = false
export(int) var speed = 40
var motion = Vector2(0, 0)

onready var player = Player

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	if active and following:
		var angle = get_angle_to(player.get_position())
		motion = Vector2(speed * cos(angle), speed * sin(angle))
	move_and_slide(motion)
extends Area2D

var angle = 0
var new_angle = 0

var colliding = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	angle = clamp(angle + 1, angle, new_angle)
	set_rotation(deg2rad(angle))
	
func rotate():
	new_angle += 90

func _on_Platform_body_entered(body):
	if body == Player:
		colliding = true

func _on_Platform_body_exited(body):
	if body == Player:
		colliding = false

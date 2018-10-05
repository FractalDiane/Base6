extends KinematicBody2D

var speed = 4
var direction = 0

func _ready():
	pass

func _process(delta):
	var vel_x
	var vel_y
	
	if direction == 0:
		vel_x = speed
		vel_y = 0
	elif direction == 90:
		vel_x = 0
		vel_y = -speed
	elif direction == 180:
		vel_x = -speed
		vel_y = 0
	elif direction == 270:
		vel_x = 0
		vel_y = speed
	
	var velocity = Vector2(vel_x,vel_y)
	
	if get_position().x < -20 or get_position().x > 180 or get_position().y < -20 or get_position().y > 164:
		queue_free()
	
	set_rotation_degrees(direction)
	move_and_collide(velocity)

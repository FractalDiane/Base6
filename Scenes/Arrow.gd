extends KinematicBody2D

var speed = 8
var direction = 0
var angle = 0
var hit = false

var vel_x = 0
var vel_y = 0

func _ready():
	pass

func _physics_process(delta):
	set_z_index(get_position().y)
	
	if not hit:
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
	else:
		if direction == 0:
			vel_x = -0.5
		elif direction == 90:
			vel_x = 0
		elif direction == 180:
			vel_x = 0.5
		elif direction == 270:
			vel_x = 0
		
	if hit:
		vel_y += 0.5
		direction += 8
	
	var velocity = Vector2(vel_x,vel_y)
	
	if get_position().x < -20 or get_position().x > 180 or get_position().y < -20 or get_position().y > 164:
		queue_free()
	
	set_rotation_degrees(-direction)
	var coll = move_and_collide(velocity)
	
	if coll != null:
		$SoundPlink.play(0)
		speed = 0
		vel_y = -6
		$CollisionPolygon2D.set_disabled(true)
		hit = true
	
		
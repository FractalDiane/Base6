extends KinematicBody2D

var speed = 8
var direction = 0
var angle = 0
var hit = false

var vel_x = 0
var vel_y = 0

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
		vel_y += controller.convert_to_seconds(0.5, delta)
		direction += controller.convert_to_seconds(8, delta)
	
	var velocity = Vector2(vel_x,vel_y)
	
	if get_position().x < -20 or get_position().x > 180 or get_position().y < -20 or get_position().y > 164:
		queue_free()
	
	set_rotation_degrees(-direction)
	var coll = move_and_collide(controller.convert_to_seconds(velocity, delta))
	
	if coll:
		$SoundPlink.play(0)
		speed = 0
		vel_y = -6
		$CollisionPolygon2D.set_disabled(true)
		hit = true
		if coll.collider.is_in_group("OrbSwitch"):
			coll.collider.press()
		if coll.collider.is_in_group("Enemies"):
			coll.collider.deal_damage()
		if coll.collider.is_in_group("SesdinBoss"):
			coll.collider.block()
		if coll.collider.is_in_group("SesdinShots"):
			if not coll.collider.exploded and not coll.collider.fired:
				coll.collider.explode()
				get_tree().get_root().get_node("Node2D").get_node("SesdinBoss").damage()

func coll_manually():
	$SoundPlink.play(0)
	speed = 0
	vel_y = -6
	$CollisionPolygon2D.set_disabled(true)
	hit = true

extends Area2D

export(int) var move_range = 32
export(float) var time = 2
export(bool) var vertical = false

var angle = 90
var target_angle = 90
var radius = 24

var colliding = false
var colliding_body

#var t = 0
var add = 0
onready var startpos = get_position()
onready var player = Player
onready var area = $Area2D

func _physics_process(delta):
	#set_z_index(get_position().y)
	#t += 1
	#add = controller.wave(0, move_range, time, 0, t, delta)
	#angle -= 2
	angle = clamp(angle - 2, target_angle, target_angle + 90)
	var angle_rad = deg2rad(angle)
	var pos_x = (radius * 2) * cos(angle_rad) + 36
	var pos_y = radius * sin(angle_rad)
	
	var add_vector = Vector2(pos_x, pos_y)
	var velocity = ((startpos + add_vector) - position) / delta
	set_position(startpos + add_vector)
	if colliding:
		player.move_and_slide(velocity)
	
#	if get_slide_count() > 0:
#		colliding = true
#	else:
#		colliding = false
	

	
	#if player in area.get_overlapping_bodies():
		#player.motion.x += add
		
func shift():
	target_angle -= 90
	

func _on_Platform_body_entered(body):
	colliding = true
	colliding_body = body

func _on_Platform_body_exited(body):
	body.set("platform_motion", Vector2(0,0))
	colliding = false
	colliding_body = null

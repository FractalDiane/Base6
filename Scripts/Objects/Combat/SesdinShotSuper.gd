extends KinematicBody2D

var angle = round(rand_range(0,359))
var dir = 0
var speed = 0
var damage = 6
var sc = 0
var fired = false
var exploded = false
var alpha = 1

var grow_speed = 0.02

onready var player = Player
onready var spr = $Sprite

func _ready():
	set_scale(Vector2(0,0))

func _physics_process(delta):
	set_z_index(180)
	
	if exploded:
		alpha = clamp(alpha - 0.08,0,1)
	
	set_modulate(Color(1,1,1,alpha))
	
	if get_position().x > 200 or get_position().y > 200 or get_position().x < -20 or get_position().y < -20:
		queue_free()
	
	if not fired:
		if not exploded:
			sc = clamp(sc + grow_speed * delta * 60,0,4)
		else:
			sc += 0.1
		set_scale(Vector2(sc, sc))
	
	#angle += 4
	#set_rotation(deg2rad(angle))
	
	var motion
	if not exploded:
		motion = Vector2(cos(dir), sin(dir))
	else:
		motion = Vector2(0,0)
	move_and_slide(motion * speed)
	
	if fired and not exploded:
		if get_slide_count() > 0:
			if get_slide_collision(0).collider.is_in_group("Player") and player.state != player.NO_INPUT:
				controller.player_damage(damage)
				player.iframes = true
				player.get_node("TimerIFrames").start()
				queue_free()

func _on_TimerFire_timeout():
	if not exploded:
		$SoundFire.play(0)
		$Trail.set_emitting(true)
		dir = get_angle_to(player.get_position())
		speed = 200
		fired = true

func explode():
	$SoundExplode.play(0)
	$SoundExplode2.play(0)
	exploded = true

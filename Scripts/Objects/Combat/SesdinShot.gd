extends KinematicBody2D

var angle = round(rand_range(0,359))
var dir = 0
var speed = 80
var damage = 3
var sc = 0
var exploded = false

onready var player = Player
onready var spr = $Sprite

func _ready():
	set_scale(Vector2(0,0))

func _physics_process(delta):
	if get_position().x > 200 or get_position().y > 200 or get_position().x < -20 or get_position().y < -20:
		queue_free()
	
	if not exploded:
		sc = clamp(sc + 0.05,0,1)
	else:
		sc += 0.1
	set_scale(Vector2(sc, sc))
	
	angle += 4
	spr.set_rotation(deg2rad(angle))
	
	var motion
	if not exploded:
		motion = Vector2(cos(deg2rad(dir)), sin(deg2rad(dir)))
	else:
		motion = Vector2(0,0)
	move_and_slide(motion * speed)
	
	if get_slide_count() > 0:
		if get_slide_collision(0).collider.is_in_group("Player") and player.state != player.NO_INPUT:
			controller.player_damage(damage)
			player.iframes = true
			player.get_node("TimerIFrames").start()
			queue_free()
	
	if exploded:
		if get_slide_count() > 0:
			var coll = get_slide_collision(0).collider
			if coll.is_in_group("SesdinBoss") and not coll.iframes:
				coll.damage()
	
func explode():
	$SoundExplode.play(0)
	$SoundExplode2.play(0)
	exploded = true

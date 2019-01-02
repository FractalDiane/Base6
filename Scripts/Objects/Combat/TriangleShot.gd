extends KinematicBody2D

const SPEED = 500

var sc = 0

var damage = 2

var angle = 0
var motion = Vector2(0,0)
var fired = false

onready var spr = $Sprite
onready var player = Player

func _ready():
	angle = get_angle_to(player.get_position())
	$Sprite.set_rotation(angle)
	
func _physics_process(delta):
	sc = clamp(sc + 0.03 * delta * 60,0,1)
	#spr.set_modulate(Color(1,1,1,alpha))
	set_scale(Vector2(sc, sc))
	
	if fired:
		motion = Vector2(cos(angle), sin(angle))
		move_and_slide(motion * SPEED * delta * 60)
		
		if get_slide_count() > 0:
			if get_slide_collision(0).collider.is_in_group("Player") and player.state != player.NO_INPUT:
				controller.player_damage(damage)
				player.iframes = true
				player.get_node("TimerIFrames").start()
				queue_free()
		
	if get_position().x < -10 or get_position().x > 200 or get_position().y < -10 or get_position().y > 160:
		queue_free()

func _on_TimerShoot_timeout():
	fired = true

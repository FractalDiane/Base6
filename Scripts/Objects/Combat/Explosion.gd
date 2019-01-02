extends Area2D

var damage = 3

var angle = 0
var exploded = false
var sc = 1
var alpha = 1
var fade = false
var rot_speed = 1

onready var player = Player

func _physics_process(delta):
	angle += rot_speed
	set_rotation(deg2rad(angle))
	if exploded:
		sc += 0.04
	set_scale(Vector2(sc, sc))
	
	if fade:
		alpha = clamp(alpha - 0.03,0,1)
		if alpha <= 0:
			queue_free()
		
	set_modulate(Color(1,1,1,alpha))

func _on_TimerExplode_timeout():
	$SoundExplode.play(0)
	rot_speed = 3
	$Sprite.play("solid")
	exploded = true
	$TimerFade.start()

func _on_Explosion_body_entered(body):
	if exploded and alpha > 0.1 and body == player:
		controller.player_damage(damage)
		player.iframes = true
		player.get_node("TimerIFrames").start()
		
func _on_TimerFade_timeout():
	fade = true

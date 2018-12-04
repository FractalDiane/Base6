extends Area2D

var sc = 0
var alpha = 1
var fade = false

var damage = 3

onready var spr = $Sprite
onready var player = Player

func _ready():
	pass

func _physics_process(delta):
	set_z_index(get_position().y)
	
	if fade:
		alpha = clamp(alpha - 0.08,0,1)
	set_modulate(Color(1,1,1,alpha))
	if fade and alpha <= 0:
		queue_free()
	
	sc = clamp(sc + 0.015,0,1)
	spr.set_scale(Vector2(sc,sc))
	
	if spr.get_frame() >= 2:
		spr.stop()
	
	if player in get_overlapping_bodies() and not player.iframes and player.state != player.NO_INPUT:
		controller.player_damage(damage)
		player.iframes = true
		player.get_node("TimerIFrames").start()

func _on_TimerActivate_timeout():
	$SoundSpike.play(0)
	$CollisionShape2D.set_disabled(false)
	$Sprite.play("active")
	$TimerFade.start()

func _on_TimerFade_timeout():
	fade = true

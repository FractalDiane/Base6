extends Area2D

export(bool) var vertical = false

var alpha = 1
var fade = false
var grow = false
var damage = false
var amount = 5
var sc = 0.25

onready var player = Player

func _ready():
	$TimerShow.start()

func _physics_process(delta):
	if grow:
		sc += 0.05 * delta * 60
	set_scale(Vector2(sc, 20))
	if fade:
		alpha = clamp(alpha - 0.05 * delta * 60,0,1)
	set_modulate(Color(0,0,0,alpha))
	
	if fade and alpha <= 0:
		queue_free()

func _on_TimerShow_timeout():
	if vertical:
		set_rotation_degrees(90)
	$SoundWarning.play(0)
	show()
	$TimerBlink1.start()

func _on_TimerBlink1_timeout():
	hide()
	$TimerBlink2.start()

func _on_TimerBlink2_timeout():
	$SoundWarning.play(0)
	show()
	$TimerBlink3.start()

func _on_TimerBlink3_timeout():
	hide()
	$TimerActivate.start()

func _on_TimerActivate_timeout():
	show()
	$SoundActivate.play(0)
	grow = true
	damage = true
	$TimerFade.start()

func _on_TimerFade_timeout():
	fade = true
	damage = false
	$TimerDestroy.start()

func _on_Laser_body_entered(body):
	if body == player and damage:
		if player.state != player.NO_INPUT:
			controller.player_damage(amount)
			player.iframes = true
			player.get_node("TimerIFrames").start()

func _on_TimerDestroy_timeout():
	queue_free()

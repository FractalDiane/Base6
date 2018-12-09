extends KinematicBody2D

var dir_x = 0
var dir_y = 0
var speed = 12
var damage = 1
var angle = round(randf(359))

var sc = 1
var fade = false

onready var player = Player

func _physics_process(delta):
	set_z_index(get_position().y)
	angle += controller.convert_to_seconds(10, delta)
	
	if fade:
		sc = clamp(sc - 0.08,0,1)
		if sc <= 0:
			queue_free()
	
	set_rotation_degrees(angle)
	set_scale(Vector2(sc, sc))
	move_and_slide(speed * Vector2(dir_x, dir_y))
	
	#if get_slide_count() > 0: and not fade and player.state != player.NO_INPUT:
	if get_slide_count() > 0:
		if get_slide_collision(0).collider.is_in_group("Player") and not fade and player.state != player.NO_INPUT:
			controller.player_damage(damage)
			player.iframes = true
			player.get_node("TimerIFrames").start()
			queue_free()

func _on_TimerExpire_timeout():
	fade = true

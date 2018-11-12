extends StaticBody2D

export(bool) var active = true
export(float) var shot_interval = 2
export(int) var shot_speed = 60
export(int) var shot_damage = 1
export(float) var expiry_time = 2

var shot = preload("res://Instances/SentryShot.tscn")

onready var player = Player

func _ready():
	set_z_index(get_position().y)
	
	$TimerShoot.set_wait_time(shot_interval)
	$TimerShoot.start()

func shoot():
	var angle = get_angle_to(Vector2(player.get_position().x, player.get_position().y + 6))
	$SoundShoot.play(0)
	var current_shot = shot.instance()
	current_shot.set_position(Vector2(get_position().x, get_position().y - 8))
	current_shot.dir_x = cos(angle)
	current_shot.dir_y = sin(angle)
	current_shot.speed = shot_speed
	current_shot.damage = shot_damage
	current_shot.get_node("TimerExpire").set_wait_time(expiry_time)
	get_tree().get_root().get_node("Node2D").add_child(current_shot)

func _on_TimerShoot_timeout():
	shoot()

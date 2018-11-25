extends KinematicBody2D

export(int) var move_range = 0
export(float) var time = 1
export(float) var shot_interval = 2
export(int) var shot_speed = 1
export(int) var shot_damage = 1
export(float) var expiry_time = 2

var shot = preload("res://Instances/SentryShot.tscn")

var t = 0
var add = 0
onready var startpos = get_position()
onready var player = Player

func _ready():
	#set_z_index(get_position().y)
	
	$TimerShoot.set_wait_time(shot_interval)
	$TimerShoot.start()
	
func _physics_process(delta):
	t += 1
	add = controller.wave(0, move_range, time, 0, t, delta)
	
	var add_vector = Vector2(0, add)
	
	set_position(startpos + add_vector)

func shoot():
	#var angle = get_angle_to(Vector2(player.get_position().x, player.get_position().y + 6))
	$SoundShoot.play(0)
	var current_shot = shot.instance()
	current_shot.set_position(Vector2(get_position().x, get_position().y))
	#current_shot.dir_x = cos(angle)
	#current_shot.dir_y = sin(angle)
	current_shot.dir_x = -deg2rad(180) * scale.x
	current_shot.speed = shot_speed
	current_shot.damage = shot_damage
	current_shot.get_node("TimerExpire").set_wait_time(expiry_time)
	get_tree().get_root().get_node("Node2D").add_child(current_shot)

func _on_TimerShoot_timeout():
	shoot()

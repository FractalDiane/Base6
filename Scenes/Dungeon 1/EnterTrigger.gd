extends Area2D

var timer
onready var player = Player
var pathblock

func _ready():
	$JumpPoint.set_physics_process(false)
	$JumpPoint2.set_physics_process(false)
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.set_wait_time(.1)
	timer.set_one_shot(true)

func _process(delta):
	var coll = get_overlapping_bodies()
	if player in coll:
		get_parent().activate()
		set_process(false)
		timer.start()
		pathblock = add_child(load("res://Instances/Objects/PathBlocker.tscn").instance())

func _on_timer_timeout():
	$JumpPoint.set_physics_process(true)
	$JumpPoint2.set_physics_process(true)

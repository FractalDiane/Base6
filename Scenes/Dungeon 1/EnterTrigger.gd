extends Area2D

var timer
var pathblocker = preload("res://Instances/Objects/PathBlocker.tscn")
var pathblock
var pathcollider = preload("res://Instances/Objects/PathCollision.tscn")
var pathExists = true

onready var path = pathcollider.instance()
onready var player = Player

func _ready():
	$PitController.add_child(path)
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
		togglePath()

func _on_timer_timeout():
	$JumpPoint.set_physics_process(true)
	$JumpPoint2.set_physics_process(true)

func togglePath():
	pathExists = not pathExists
	if pathExists:
		path = pathcollider.instance()
		$PitController.add_child(path)
		$Transition.position.y -= 100
		if pathblock != null:
			remove_child(pathblock)
	else:
		path.get_parent().remove_child(path)
		pathblock = pathblocker.instance()
		add_child(pathblock)
		$Transition.position.y += 100
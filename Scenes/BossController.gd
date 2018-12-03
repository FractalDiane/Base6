extends Node2D

var spike = preload("res://Instances/Objects/SpikeTrail.tscn")
var followTrail = false
var squareTrail = false
var spikePoint = Vector2(0, 0)
var trailSpeed = 10
var trailInterval = .2
var squareInterval = 1.5
var squareOffsets = []
var followTimer
var squareTimer
var squareTimer2
var stopTimer

onready var player = Player

func _ready():
	followTimer = Timer.new()
	followTimer.connect("timeout",self,"_on_follow_timeout") 
	add_child(followTimer)
	followTimer.set_wait_time(trailInterval)
	followTimer.set_one_shot(true)
	
	squareTimer = Timer.new()
	squareTimer.connect("timeout",self,"_on_square_timeout") 
	add_child(squareTimer)
	squareTimer.set_wait_time(squareInterval)
	squareTimer.set_one_shot(true)
	squareTimer.start()
	
	squareTimer2 = Timer.new()
	squareTimer2.connect("timeout",self,"_on_square2_timeout") 
	add_child(squareTimer2)
	squareTimer2.set_wait_time(trailInterval)
	squareTimer2.set_one_shot(true)
	squareTimer2.start()
	
	stopTimer = Timer.new()
	stopTimer.connect("timeout",self,"_on_stop_timeout") 
	add_child(stopTimer)
	stopTimer.set_wait_time(1)
	stopTimer.set_one_shot(true)

#func _physics_process(delta):

func _on_follow_timeout():
	if followTrail:
		var angle = atan2(player.position.y - spikePoint.y,player.position.x - spikePoint.x)
		spikePoint = spikePoint + Vector2(trailSpeed * cos(angle), trailSpeed * sin(angle))
		var newspike = spike.instance()
		newspike.position = spikePoint
		add_child(newspike)
		followTimer.start()

func _on_square_timeout():
	print(squareTrail)
	if squareTrail:
		squareOffsets.append(0)
		squareTimer.start()

func _on_square2_timeout():
	print(squareOffsets)
	for i in range(squareOffsets.size()):
		var newspike = spike.instance()
		newspike.position = Vector2(50, 120 - squareOffsets[i])
		add_child(newspike)
		newspike = spike.instance()
		newspike.position = Vector2(110, squareOffsets[i])
		add_child(newspike)
		newspike = spike.instance()
		newspike.position = Vector2(squareOffsets[i] - 10, 40)
		add_child(newspike)
		newspike = spike.instance()
		newspike.position = Vector2(150 - squareOffsets[i], 80)
		add_child(newspike)
		squareOffsets[i] += trailSpeed
	if squareOffsets.size() > 0 and squareOffsets[0] >= 200:
		squareOffsets.remove(0)
	squareTimer2.start()

func _on_stop_timeout():
	followTrail = false
	squareTrail = false
	print("Stop")

func squareSpikes(duration): #Start a square spike pattern for duration seconds
	squareTrail = true
	squareTimer.start()
	squareTimer2.start()
	stopTimer.set_wait_time(duration)
	stopTimer.start()

func followSpikes(duration, x = 0, y = 0): #Create a spike trail for duration seconds starting at position (x,y)
	followTrail = true
	spikePoint = Vector2(x, y)
	stopTimer.set_wait_time(duration)
	stopTimer.start()
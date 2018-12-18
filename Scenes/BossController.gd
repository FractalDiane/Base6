extends Node2D

var spike = preload("res://Instances/Objects/SpikeTrail.tscn")
var ghast = preload("res://Instances/Enemies/Ghast.tscn")
var sideeye = preload("res://Instances/Enemies/SideEye.tscn")
var sidemouth = preload("res://Instances/Enemies/SideMouth.tscn")
var downeye = preload("res://Instances/Enemies/DownEye.tscn")
var downmouth = preload("res://Instances/Enemies/DownMouth.tscn")
var followTrail = false
var squareTrail = false
var spikePoints = []
var trailSpeed = 10
var trailInterval = .2
var squareInterval = 1.5
var squareOffsets = []
var followTimer
var squareTimer
var squareTimer2
var attackTimer
var stopTimer
var eyeTimer
var phase = 1
var attacks_left = 5
var spawnpoints = [Vector2(80, 30), Vector2(30, 80), Vector2(150, 80), Vector2(80, 110), Vector2(30, 40), Vector2(130, 40), Vector2(30, 100), Vector2(130, 100)]

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
	
	squareTimer2 = Timer.new()
	squareTimer2.connect("timeout",self,"_on_square2_timeout") 
	add_child(squareTimer2)
	squareTimer2.set_wait_time(trailInterval)
	squareTimer2.set_one_shot(true)
	
	attackTimer = Timer.new()
	attackTimer.connect("timeout",self,"_on_attack_timeout") 
	add_child(attackTimer)
	attackTimer.set_wait_time(3)
	attackTimer.set_one_shot(true)
	
	stopTimer = Timer.new()
	stopTimer.connect("timeout",self,"_on_stop_timeout") 
	add_child(stopTimer)
	stopTimer.set_wait_time(1)
	stopTimer.set_one_shot(true)
	
	eyeTimer = Timer.new()
	eyeTimer.connect("timeout",self,"_on_eye_timeout") 
	add_child(eyeTimer)
	eyeTimer.set_wait_time(5)
	eyeTimer.set_one_shot(true)
	
	choose_attack()

func _on_follow_timeout():
	if followTrail:
		if len(spikePoints) == 0:
			followTrail = false
			return
		for i in range(len(spikePoints)):
			var angle = atan2(player.position.y - spikePoints[i].y,player.position.x - spikePoints[i].x)
			spikePoints[i] = spikePoints[i] + Vector2(trailSpeed * cos(angle), trailSpeed * sin(angle))
			var newspike = spike.instance()
			newspike.position = spikePoints[i]
			add_child(newspike)
			followTimer.start()

func _on_square_timeout():
	if squareTrail:
		squareOffsets.append(0)
		squareTimer.start()
		squareTimer2.start()

func _on_square2_timeout():
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
	if squareOffsets.size() > 0:
		squareTimer2.start()
		if squareOffsets[0] >= 200:
			squareOffsets.remove(0)

func _on_stop_timeout():
	spikePoints.remove(0)
	if len(spikePoints) > 0:
		stopTimer.start()
	squareTrail = false

func _on_eye_timeout():
	match phase:
		1:
			attacks_left = 3
			choose_attack()

func _on_attack_timeout():
	choose_attack()

func choose_attack():
	match phase:
		1:
			if attacks_left == 0:
				spawnEye()
				eyeTimer.start()
				return
			var rand_attack = randi() % 2
			match rand_attack:
				0:
					var i = randi() % 4
					var location
					match i:
						0:
							location = Vector2(0, randi() % 120)
						1:
							location = Vector2(180, randi() % 120)
						2:
							location = Vector2(randi() % 180, 0)
						3:
							location = Vector2(randi() % 180, 120)
					followSpikes(5, location)
					attackTimer.start()
				1:
					spawnGhasts(1)
					attackTimer.start()
	attacks_left -= 1

func squareSpikes(duration): #Start a square spike pattern for duration seconds
	squareTrail = true
	squareTimer.start()
	stopTimer.set_wait_time(duration)
	stopTimer.start()

func followSpikes(duration, location = Vector2(0, 0)): #Create a spike trail for duration seconds starting at position (x,y)
	followTrail = true
	spikePoints.append(location)
	followTimer.start()
	if stopTimer.is_stopped():
		stopTimer.set_wait_time(duration)
		stopTimer.start()

func spawnGhasts(amount):
	if amount == 1:
		spawn_ghast(spawnpoints[randi() % 8])
	else:
		var tempspawns = spawnpoints.duplicate()
		for i in range(amount):
			var index = randi() % len(tempspawns)
			spawn_ghast(tempspawns[index])
			tempspawns.remove(index)
		

func spawnEye(mouthNum = 0):
	if mouthNum == 0:
		spawn_eye(spawnpoints[randi() % 3])
	else:
		var tempspawns = spawnpoints.duplicate().resize(3)
		var mouth = false
		for i in range(mouthNum):
			var index = randi() % len(tempspawns)
			spawn_eye(tempspawns[index], mouth)
			tempspawns.remove(index)
			if not mouth:
				mouth = true

func spawn_eye(spawnpoint, mouth = false):
	var eye
	if spawnpoint.x == 80:
		if mouth:
			eye = downmouth.instance()
		else:
			eye = downeye.instance()
	else:
		if mouth:
			eye = sidemouth.instance()
		else:
			eye = sideeye.instance()
		if spawnpoint.x == 130:
			eye.scale.x = -1
	eye.position = spawnpoint
	add_child(eye)

func spawn_ghast(spawnpoint): #Spawn a ghast at position (x,y)
	var newghast = ghast.instance()
	newghast.position = spawnpoint
	add_child(newghast)
extends KinematicBody2D

var active = false
var attack_count = 0
var phase = 1
var attack_dir = "castdown"

var shot = preload("res://Instances/Enemies/SesdinShot.tscn")
var shot_homing = preload("res://Instances/Enemies/SesdinShotHoming.tscn")
var spike = preload("res://Instances/Enemies/SesdinSpike.tscn")
var spikepoint = preload("res://Instances/Enemies/Spikepoint.tscn")

onready var points = get_tree().get_root().get_node("Node2D").get_node("TeleportPoints")
onready var pitcontroller = get_tree().get_root().get_node("Node2D").get_node("PitController")

func _ready():
	$Sprite.hide()
	$CollisionShape2D.set_disabled(true)
	$HB/CollisionPolygon2D.set_disabled(true)

func _physics_process(delta):
	set_z_index(get_position().y)

func _on_TimerTP_timeout():
	$SoundTeleport.play(0)
	$PartsTeleport.set_emitting(true)
	
	var rng = round(rand_range(0,4))
	var target = points.get_child(rng)
	set_position(target.get_position())
	$Sprite.play(target.sesdin_direction)
	attack_dir = target.sesdin_attack_direction
	
	$Sprite.show()
	$CollisionShape2D.set_disabled(false)
	$HB/CollisionPolygon2D.set_disabled(false)
	
	$TimerAttack.set_wait_time(rand_range(0.7,1.1))
	$TimerAttack.start()

func _on_TimerAttack_timeout():
	attack_count += 1
	var attack = int(round(rand_range(0,1)))
	
	match(attack):
		0: # Triple shot
			$SoundShoot.play(0)
			$Sprite.play(attack_dir)
			
			var dirs = []
			if attack_dir == "castdown":
				dirs = [-270, -225, -315]
			elif attack_dir == "castleft":
				dirs = [180, 135, 215]
			else:
				dirs = [0, -45, 45]
			
			for dir in dirs:
				var shotn = shot.instance()
				shotn.set_position(get_position())
				shotn.dir = dir
				get_tree().get_root().add_child(shotn)
			
			$TimerTPOut.set_wait_time(0.8)
			$TimerTPOut.start()
			
		1: # Homing shots
			$SoundCharge.play(0)
			#$Sprite.play(attack_dir)
			
			var shot1 = shot_homing.instance()
			shot1.set_position(Vector2(get_position().x - 10, get_position().y - 20))
			get_tree().get_root().add_child(shot1)
			var shot2 = shot_homing.instance()
			shot2.set_position(Vector2(get_position().x + 10, get_position().y - 20))
			get_tree().get_root().add_child(shot2)
			
			$TimerHomingPose.start()
			
		2: # Spikes
			$Sprite.play(attack_dir)
			var spike1 = spike.instance()
			spike1.set_position(Player.get_position())
			get_tree().get_root().add_child(spike1)
			
			var spike2p = spikepoint.instance()
			get_tree().get_root().add_child(spike2p)
			while not spike2p in pitcontroller.get_overlapping_areas():
				spike2p.set_position(Vector2(rand_range(8,152), rand_range(32,120)))
			var spike2 = spike.instance()
			get_tree().get_root().add_child(spike2)
			spike2.set_position(spike2p.get_position())
			spike2p.queue_free()
			
			var spike3p = spikepoint.instance()
			get_tree().get_root().add_child(spike3p)
			while not spike3p in pitcontroller.get_overlapping_areas():
				spike3p.set_position(Vector2(rand_range(8,152), rand_range(32,120)))
			var spike3 = spike.instance()
			get_tree().get_root().add_child(spike3)
			spike3.set_position(spike2p.get_position())
			spike3p.queue_free()
			
func _on_TimerTPOut_timeout():
	$SoundTeleport.play(0)
	$PartsTeleport2.set_emitting(true)
	
	$Sprite.hide()
	$CollisionShape2D.set_disabled(true)
	$HB/CollisionPolygon2D.set_disabled(true)
	$TimerTP.set_wait_time(rand_range(1.45,2))
	$TimerTP.start()

func _on_TimerHomingPose_timeout():
	$Sprite.play(attack_dir)
	$TimerTPOut.set_wait_time(1)
	$TimerTPOut.start()

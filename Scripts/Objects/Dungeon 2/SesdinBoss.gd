extends KinematicBody2D

var active = false
var attack_count = 0
var phase = 1
var attack_dir = "castdown"

var health = 4
var iframes = false
var super_interval = 4

var dead = false

var shot = preload("res://Instances/Enemies/SesdinShot.tscn")
var shot_homing = preload("res://Instances/Enemies/SesdinShotHoming.tscn")
var spike = preload("res://Instances/Enemies/SesdinSpike.tscn")
#var spikepoint = preload("res://Instances/Enemies/Spikepoint.tscn")
var supershot = preload("res://Instances/Enemies/SesdinShotSuper.tscn")

onready var points = get_tree().get_root().get_node("Node2D").get_node("TeleportPoints")
onready var pitcontroller = get_tree().get_root().get_node("Node2D").get_node("PitController")

func _ready():
	$Sprite.hide()
	#$CollisionShape2D.set_disabled(true)
	$CollisionPolygon2D.set_disabled(true)

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
	#$CollisionShape2D.set_disabled(false)
	$CollisionPolygon2D.set_disabled(false)
	
	if health < 3:
		$TimerAttack.set_wait_time(rand_range(0.3,0.8))
	else:
		$TimerAttack.set_wait_time(rand_range(0.7,1.1))
	$TimerAttack.start()

func _on_TimerAttack_timeout():
	attack_count += 1
	var attack
	if attack_count % super_interval == 0:
		attack = 3
	else:
		attack = int(round(rand_range(0,2)))
	
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
			
			var homing_rng = randf()
			
			if homing_rng < 0.5:
				var shot1 = shot_homing.instance()
				shot1.set_position(Vector2(get_position().x - 10, get_position().y - 20))
				get_tree().get_root().add_child(shot1)
				var shot2 = shot_homing.instance()
				shot2.set_position(Vector2(get_position().x + 10, get_position().y - 20))
				get_tree().get_root().add_child(shot2)
				
				if health < 3:
					var shot3 = shot_homing.instance()
					shot3.set_position(Vector2(get_position().x, get_position().y - 30))
					get_tree().get_root().add_child(shot3)
					
				if health < 2:
					var shot4 = shot_homing.instance()
					shot4.set_position(Vector2(get_position().x, get_position().y - 40))
					get_tree().get_root().add_child(shot4)
			else:
				var shot1 = shot_homing.instance()
				shot1.set_position(Vector2(rand_range(8,152), rand_range(8,136)))
				get_tree().get_root().add_child(shot1)
				var shot2 = shot_homing.instance()
				shot2.set_position(Vector2(rand_range(8,152), rand_range(8,136)))
				get_tree().get_root().add_child(shot2)
				
				if health < 3:
					var shot3 = shot_homing.instance()
					shot3.set_position(Vector2(rand_range(8,152), rand_range(8,136)))
					get_tree().get_root().add_child(shot3)
					
				if health < 2:
					var shot4 = shot_homing.instance()
					shot4.set_position(Vector2(rand_range(8,152), rand_range(8,136)))
					get_tree().get_root().add_child(shot4)
				
			$TimerHomingPose.start()
			
		2: # Spikes
			$SoundCharge2.play(0)
			$Sprite.play(attack_dir)
			
			var spike1 = spike.instance()
			spike1.set_position(Player.get_position())
			get_tree().get_root().add_child(spike1)
			
			var spike2 = spike.instance()
			spike2.set_position(Vector2(Player.get_position().x + rand_range(-20,20), Player.get_position().y + rand_range(-20,20)))
			get_tree().get_root().add_child(spike2)
			
			var spike3 = spike.instance()
			spike3.set_position(Vector2(Player.get_position().x + rand_range(-35,35), Player.get_position().y + rand_range(-35,35)))
			get_tree().get_root().add_child(spike3)
			
			if health < 4:
				var spike4 = spike.instance()
				spike4.set_position(Vector2(Player.get_position().x + rand_range(-28,28), Player.get_position().y + rand_range(-28,28)))
				get_tree().get_root().add_child(spike4)
			if health < 3:
				var spike5 = spike.instance()
				spike5.set_position(Vector2(Player.get_position().x + rand_range(-28,28), Player.get_position().y + rand_range(-28,28)))
				get_tree().get_root().add_child(spike5)
			if health < 2:
				var spike6 = spike.instance()
				spike6.set_position(Vector2(Player.get_position().x + rand_range(-28,28), Player.get_position().y + rand_range(-28,28)))
				get_tree().get_root().add_child(spike6)
			
			$TimerTPOut.set_wait_time(2)
			$TimerTPOut.start()
			
		3: # Super attack
			$SoundCharge3.play(0)
			$Sprite.play(attack_dir)
			
			var super = supershot.instance()
			super.set_position(get_position())
			match(health):
				4:
					super.grow_speed = 0.02
					super.get_node("TimerFire").set_wait_time(5)
					$TimerTPOut.set_wait_time(5)
				3:
					super.grow_speed = 0.03
					super.get_node("TimerFire").set_wait_time(3.5)
					$TimerTPOut.set_wait_time(4)
				2:
					super.grow_speed = 0.04
					super.get_node("TimerFire").set_wait_time(2)
					$TimerTPOut.set_wait_time(2)
				1:
					super.grow_speed = 0.06
					super.get_node("TimerFire").set_wait_time(1.25)
					$TimerTPOut.set_wait_time(1.5)
					
			get_tree().get_root().add_child(super)
			
			
			$TimerTPOut.start()
			
func block():
	$SoundBlock.play(0)
	$PartsBlock.set_emitting(true)
	iframes = true
	$TimerIFrames.start()

func damage():
	$SoundDamage.play(0)
	health -= 1
	$TimerTPOut.set_wait_time(0.1)
	$TimerTPOut.start()
	if health <= 0:
		defeat()
		return
	attack_count = 0
	super_interval += 1
	iframes = true
	$TimerIFrames.start()
	
func defeat():
	dead = true
	$SoundDie.play(0)
	$TimerTP.stop()
	$TimerAttack.stop()
	get_tree().get_root().get_node("Node2D").get_node("SesdinIntro").get_node("MusicBoss").stop()
	$TimerEnd.start()

func _on_TimerTPOut_timeout():
	$SoundTeleport.play(0)
	$PartsTeleport2.set_emitting(true)
	
	$Sprite.hide()
	#$CollisionShape2D.set_disabled(true)
	$CollisionPolygon2D.set_disabled(true)
	match(health):
		4:
			$TimerTP.set_wait_time(rand_range(1.45,2))
		3:
			$TimerTP.set_wait_time(rand_range(1.15,1.7))
		2:
			$TimerTP.set_wait_time(rand_range(1.1,1.4))
		1:
			$TimerTP.set_wait_time(rand_range(1.1,1.3))
			
	if health > 0:
		$TimerTP.start()

func _on_TimerHomingPose_timeout():
	$Sprite.play(attack_dir)
	$TimerTPOut.set_wait_time(1)
	$TimerTPOut.start()

func _on_TimerIFrames_timeout():
	iframes = false

func _on_TimerEnd_timeout():
	get_tree().get_root().get_node("Node2D").get_node("SesdinIntro").after = true
	get_tree().get_root().get_node("Node2D").get_node("SesdinIntro").get_node("SoundTeleport").play(0)
	get_tree().get_root().get_node("Node2D").get_node("SesdinIntro").get_node("PartsTeleport").set_emitting(true)
	get_tree().get_root().get_node("Node2D").get_node("SesdinIntro").get_node("Sprite").show()
	get_tree().get_root().get_node("Node2D").get_node("SesdinIntro").get_node("TimerEndDialogue").start()

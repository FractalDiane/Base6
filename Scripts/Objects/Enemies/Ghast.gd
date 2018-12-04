extends KinematicBody2D

export(int) var health = 9
export(float) var speed = 28
export(float) var knockback_distance = 5

var iframes = false
var alpha = 1
var fade = false

var move_idle_timer = rand_range(1,2)
var move_idle_speed = 0
var move_idle_dir = 0
var move_idle_end_timer = 0

var player_distance = 0
var alert = false

var attacking = 0
var cooldown = false

var motion = Vector2(0,0)

var flash = 0

var dead = false

var slam_parts = preload("res://Instances/Particles/PartsSlamImpact.tscn")
var coin = preload("res://Instances/Items/Gold.tscn")

onready var spr = $Sprite
onready var player = Player
onready var hbswat = $HitboxSwat
onready var hbslam = $HitboxSlam

func _ready():
	$TimerMoveIdle.set_wait_time(move_idle_timer)
	$TimerMoveIdle.start()

func _physics_process(delta):
	set_z_index(get_position().y)
	
	if not dead:
		player_distance = get_distance_to_player()
	
		if player_distance < 75:
			alert = true
			
		if alert:
			$TimerMoveIdle.stop()
			$TimerMoveIdleEnd.stop()
			if not attacking:
				move_alert()
			else:
				motion = Vector2(0,0)
			if player_distance < 25 and attacking == 0 and not cooldown:
				attacking = round(rand_range(1,3))
				if attacking < 3 and attacking > 0:
					spr.get_sprite_frames().set_animation_speed("swat", 12)
					spr.play("swat")
					$TimerAttackEnd.set_wait_time(5.0/12.0 + 0.1)
					$TimerAttackEnd.start()
				else:
					spr.get_sprite_frames().set_animation_speed("slam", 15)
					spr.play("slam")
					$TimerAttackEnd.set_wait_time(13.0/15.0 + 0.1)
					$TimerAttackEnd.start()
					
		if attacking < 3 and attacking > 0:
			if $TimerEnableSwatHitbox.is_stopped():
				$TimerEnableSwatHitbox.start()
			var coll = hbswat.get_overlapping_bodies()
			if player in coll and not player.iframes:
				damage_player(1, 0.3, 1)
		elif attacking == 3:
			if $TimerEnableSlamHitbox.is_stopped():
				$TimerEnableSlamHitbox.start()
			var coll = hbslam.get_overlapping_bodies()
			if player in coll and not player.iframes:
				damage_player(2, 0.4, 2)
		else:
			hbswat.get_node("CollisionPolygon2D").set_disabled(true)
			hbslam.get_node("CollisionPolygon2D").set_disabled(true)
	else:
		motion = Vector2(0,0)

	flash = clamp(flash - 0.0167,0,1)
	spr.get_material().set_shader_param("flash", flash)

	if fade:
		alpha = clamp(alpha - 0.05,0,1)
		spr.set_modulate(Color(0, 0, 0, alpha))
	
	animation_control()
	move_and_slide(motion)

func move_idle():
	move_idle_speed = rand_range(11,18)
	var move_angle = round(rand_range(0,359))
	move_idle_dir = deg2rad(move_angle)
	if move_angle < 90 or move_angle > 270:
		spr.set_flip_h(true)
	else:
		spr.set_flip_h(false)
	
	motion = Vector2(cos(move_idle_dir) * move_idle_speed, sin(move_idle_dir) * move_idle_speed)
	spr.play("walk")
	
	move_idle_end_timer = rand_range(1, 3)
	$TimerMoveIdleEnd.set_wait_time(move_idle_end_timer)
	$TimerMoveIdleEnd.start()
	
func move_idle_end():
	move_idle_speed = 0
	motion = Vector2(0,0)
	spr.play("idle")
	move_idle_timer = rand_range(2,3)
	$TimerMoveIdle.set_wait_time(move_idle_timer)
	$TimerMoveIdle.start()
	
func move_alert():
	var angle = get_angle_to(player.get_position())
	motion = Vector2(cos(angle) * speed, sin(angle) * speed)
	if angle > -PI/2 and angle < PI/2:
		spr.set_flip_h(true)
	else:
		spr.set_flip_h(false)
	spr.play("walk")
	
func attack_end():
	spr.play("idle")
	cooldown = true
	attacking = 0
	speed = clamp(speed + 1,0,50)
	$TimerAttackEndCooldown.start()
	
func damage_player(amount, corr_chance, corr_amount):
	controller.player_damage(amount)
	if randf() < corr_chance:
		controller.player_corrupt(corr_amount)
	player.iframes = true
	player.get_node("TimerIFrames").start()
	
func deal_damage():
	flash = 1
	health -= 3
	if health <= 0:
		dead = true
		death()
	else:
		iframes = true
		$TimerIFrames.start()

func deal_damage_knockback(direction):
	# Direction is a normalized Vector2()
	flash = 1
	health -= 3
	if health <= 0:
		dead = true
		death()
	else:
		set_position(get_position() + knockback_distance * direction)
		iframes = true
		$TimerIFrames.start()

func deal_damage_weak_knockback(direction):
	# Direction is a normalized Vector2()
	flash = 1
	health -= 3
	if health <= 0:
		dead = true
		death()
	else:
		set_position(get_position() + (knockback_distance / 2) * direction)
		iframes = true
		$TimerIFrames.start()

func animation_control():
	if spr.get_animation() == "swat":
		if spr.get_frame() == 1:
			$SoundSwat.play(0)
		if spr.get_frame() >= 5:
			spr.get_sprite_frames().set_animation_speed("swat", 0)
	if spr.get_animation() == "slam":
		if spr.get_frame() == 1:
			$SoundSlamSwing.play(0)
		if spr.get_frame() == 9 and not $SoundSlamImpact.is_playing():
			$SoundSlamImpact.play(0)
			#$PartsSlamImpact.set_emitting(true)
			var parts = slam_parts.instance()
			if spr.is_flipped_h():
				parts.set_position(Vector2(get_position().x + 17,get_position().y + 16))
			else:
				parts.set_position(Vector2(get_position().x - 17,get_position().y + 16))
			parts.get_node("TimerDestroy").start()
			parts.set_emitting(true)
			get_tree().get_root().get_node("Node2D").add_child(parts)
		if spr.get_frame() >= 13:
			spr.get_sprite_frames().set_animation_speed("slam", 0)

func death():
	$SoundDeath.play(0)
	$SoundDeath2.play(0)
	fade = true
	$CollisionShape2D.set_disabled(true)
	$PartsGhast.set_emitting(false)
	$PartsDeathBurst.set_emitting(true)
	$PartsDeathGlitch.set_emitting(true)
	var rng = randf()
	if rng <= 0.25:
		var coin_i = coin.instance()
		coin_i.set_position(get_position())
		if rng < 0.1:
			coin_i.gold_value = 20
			coin_i.large_sprite = true
		coin_i.enable = false
		coin_i.get_node("TimerEnable").start()
		get_tree().get_root().add_child(coin_i)
	$TimerDeath1.start()
	
func get_distance_to_player():
	var a = get_position()
	var b = player.get_position()
	var c = a - b
	return sqrt(c.x * c.x + c.y * c.y)

func _on_TimerIFrames_timeout():
	iframes = false

func _on_TimerDeath1_timeout():
	$PartsDeathGlitch.set_emitting(false)
	$TimerDeath2.start()

func _on_TimerDeath2_timeout():
	queue_free()

func _on_TimerMoveIdle_timeout():
	move_idle()

func _on_TimerMoveIdleEnd_timeout():
	move_idle_end()

func _on_TimerAttackEnd_timeout():
	attack_end()

func _on_TimerAttackEndCooldown_timeout():
	cooldown = false

func _on_TimerEnableSwatHitbox_timeout():
	if spr.is_flipped_h():
		hbswat.set_scale(Vector2(-1,1))
	else:
		hbswat.set_scale(Vector2(1,1))
	hbswat.get_node("CollisionPolygon2D").set_disabled(false)

func _on_TimerEnableSlamHitbox_timeout():
	if spr.is_flipped_h():
		hbslam.set_scale(Vector2(-1,1))
	else:
		hbslam.set_scale(Vector2(1,1))
	hbslam.get_node("CollisionPolygon2D").set_disabled(false)

func _on_HBRanged_body_entered(body):
	if body.is_in_group("Arrow"):
		body.coll_manually()
		Player.get_node("SoundDealDamage").play(0)
		deal_damage()
		alert = true

extends KinematicBody2D

var motion = Vector2(0,0)
var dash = Vector2(0,0)
var face = Vector2(0,0)
var sound = -1
var warp = false
var jumping = false
var falling = false
var respawn = false
var iframes = false

var dead = false
var fully_corrupted = false

var color = 1

var arrow = preload("res://Instances/Arrow.tscn")

onready var sight = $Sight

onready var areaU = $HitboxSwordUp
onready var areaD = $HitboxSwordDown
onready var areaL = $HitboxSwordLeft
onready var areaR = $HitboxSwordRight
onready var hbU = $HitboxSwordUp/CollisionPolygon2D
onready var hbD = $HitboxSwordDown/CollisionPolygon2D
onready var hbL = $HitboxSwordLeft/CollisionPolygon2D
onready var hbR = $HitboxSwordRight/CollisionPolygon2D

const WALKSPEED = 80
enum States{WALK, SWING, DASH, SHOOT, DIALOGUE, MENU, NO_INPUT}
var state = NO_INPUT

# ================================================================================== STATES

func _ready():
	hide()

func _physics_process(delta):
	# Depth correction
	set_z_index(get_position().y)
	# Color shift for corruption animation
	color = clamp(color + controller.convert_to_seconds(0.008, delta),0,1)
	set_modulate(Color(color,color,color))
	
	# Move sight
	var rotation = 0
	if face.y == -1: sight.set_position(Vector2(0,-10))
	elif face.y == 1: sight.set_position(Vector2(0,20))
	elif face.x != 0:
		sight.set_position(Vector2(face.x*15,5))
		rotation = 90
	sight.set_rotation_degrees(rotation)
	
	# Handle current state
	match(state):
		WALK:
			state_walk()
		SWING:
			state_swing()
		DASH:
			state_dash(delta)
		SHOOT:
			state_shoot()
		DIALOGUE:
			state_dialogue()
		MENU:
			state_menu()
		NO_INPUT:
			state_noinput(delta)
		
	deal_damage()
	
	if controller.player_health <= 0 and not dead:
		audioplayer.get_node("Music").stop()
		state = NO_INPUT
		controller.player_corruption = 0
		controller.scene_change("res://Scenes/Dead.tscn")
		dead = true
	
	if controller.player_health > 0 and controller.player_corruption >= 10 and not fully_corrupted:
		audioplayer.get_node("Music").stop()
		state = NO_INPUT
		controller.scene_change("res://Scenes/Corrupted.tscn")
		fully_corrupted = true
	
	footstep_increment(delta)
	footstep_sound()
	move_and_slide(motion)
	
	if get_slide_count() > 0:
		var coll = get_slide_collision(0)
		if coll.collider.is_in_group("Pushables"):
			coll.collider.apply_impulse(Vector2(0,0), face * 3)
	
func state_walk():
	# Set Motion and Face
	var previous = Vector2(motion.x, motion.y)
	motion.y = (int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))) * WALKSPEED
	motion.x = (int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))) * WALKSPEED
	if previous.x != motion.x:
		if motion.x != 0:
			if previous.y == motion.y and motion.y == 0:
				face.x = sign(motion.x)
				face.y = 0
			else: 
				face.x = 0
				if motion.y != 0: face.y = sign(motion.y)
		elif motion.y != 0:
			face.y = sign(motion.y)
			face.x = 0
	elif previous.y != motion.y:
		if motion.y != 0:
			if previous.x == motion.x and motion.x == 0:
				face.y = sign(motion.y)
				face.x = 0
			else: 
				face.y = 0
				if motion.x != 0: face.x = sign(motion.x)
		elif motion.x != 0:
			face.x = sign(motion.x)
			face.y = 0
	
	# Set Animations
	var walking = "walk"
	if motion.x == 0 and motion.y == 0:
		sound = -1
		walking = ""
	if face.x == 0: # Vertical
		if face.y < 0:
			$Sprite.play(walking + "up")
		else:
			$Sprite.play(walking + "down")
	else: # Horizontal
		if face.x < 0:
			$Sprite.play(walking + "left")
		else:
			$Sprite.play(walking + "right")
	
	# SWING
	if Input.is_action_just_pressed("ui_attack"):
		state = SWING
		swing_attack()
		
	# DASH
	if Input.is_action_just_pressed("ui_dash"):
		state = DASH
		dash_attack()
	
	# SHOOT
	if Input.is_action_just_pressed("ui_shoot") and controller.flag["holding_bow"] == 1:
		state = SHOOT
		shoot_bow()
		
	# POTION
	if Input.is_action_just_pressed("ui_heal"):
		if controller.player_potions > 0 and controller.player_health < 10:
			use_potion()
			controller.player_potions -= 1
		
	var current_sight = sight.get_overlapping_bodies()
	
	if not controller.bad_ending:
		for node in current_sight:
			if node.is_in_group("NPC") or node.is_in_group("Item"):
				node.show_interact = true
				node.get_node("TimerHideInteract").start()
			
	if Input.is_action_just_pressed("ui_debug1"):
		controller.flag["dungeon1_complete"] = 1
		controller.flag["holding_dungeon2key"] = 1
		controller.corrupted_cells_add += ["04","12","13","32", "43"]
		print("1")
	
	if Input.is_action_just_pressed("ui_debug2"):
		controller.flag["dungeon2_complete"] = 1
		controller.flag["holding_gatekey"] = 1
		controller.corrupted_cells_add += ["01","02","03","?1","10","11","20","21","22","30","31","40","41","42","?2"]
		print("2")
		
	if Input.is_action_just_pressed("ui_debug4"):
		controller.holding_thekey = true
		print("4")
		
func state_swing():
	stop_animation()

func state_dash(delta):
	stop_animation()
	
	# Decrease velocity after dash
	if not jumping:
		if motion.x < 0: # Left
			motion.x = clamp(motion.x + controller.convert_to_seconds(6, delta),-200,0)
		elif motion.x > 0: # Right
			motion.x = clamp(motion.x - controller.convert_to_seconds(6, delta),0,200)
	
		if motion.y < 0: # Up
			motion.y = clamp(motion.y + controller.convert_to_seconds(6, delta),-200,0)
		elif motion.y > 0: # Down
			motion.y = clamp(motion.y - controller.convert_to_seconds(6, delta),0,200)
	
func state_shoot():
	stop_animation()
	
func state_dialogue():
	pass
	
func state_menu():
	pass
	
func state_noinput(delta):
	if falling and not respawn:
		motion = Vector2(0,0)
		scale.x = clamp(scale.x - controller.convert_to_seconds(0.05, delta),0,1)
		scale.y = clamp(scale.y - controller.convert_to_seconds(0.05, delta),0,1)
		if scale.x <= 0.01:
			hide()

# ================================================================================== LOCALS

func swing_attack():
	$SoundSwing.play(0)
	$SoundSwing.set_pitch_scale(rand_range(1,1.2))
	$Sprite.set_frame(0)
	motion.x = 0
	motion.y = 0
	if face.y < 0:
		$Sprite.play("swingup")
		hbU.set_disabled(false)
	elif face.y > 0:
		$Sprite.play("swingdown")
		hbD.set_disabled(false)
	else:
		if face.x < 0:
			$Sprite.play("swingleft")
			hbL.set_disabled(false)
		elif face.x > 0:
			$Sprite.play("swingright")
			hbR.set_disabled(false)
			
	$TimerSwing.start()
	$TimerSwingAnim.start()
	
func dash_attack():
	$SoundSwing.play(0)
	$SoundSwing.set_pitch_scale(rand_range(0.75,0.9))
	$Sprite.set_frame(0)
	if face.y < 0:
		motion.y = -250
		$Sprite.play("swingup")
		hbU.set_disabled(false)
	elif face.y > 0:
		motion.y = 250
		$Sprite.play("swingdown")
		hbD.set_disabled(false)
	else:
		motion.x = 250 * face.x
		if face.x < 0:
			$Sprite.play("swingleft")
			hbL.set_disabled(false)
		elif face.x > 0:
			$Sprite.play("swingright")
			hbR.set_disabled(false)
	$TimerDash.start()
	
func shoot_bow():
	$SoundShoot.play(0)
	$Sprite.set_frame(0)
	var shootarrow = arrow.instance()
	motion.x = 0
	motion.y = 0
	if face.y < 0:
		$Sprite.play("shootup")
		shootarrow.set_position(Vector2(get_position().x,get_position().y - 1))
		shootarrow.direction = 90
	elif face.y > 0:
		$Sprite.play("shootdown")
		shootarrow.set_position(Vector2(get_position().x,get_position().y + 1))
		shootarrow.direction = 270
	else:
		if face.x < 0:
			$Sprite.play("shootleft")
		elif face.x > 0:
			$Sprite.play("shootright")
		shootarrow.set_position(Vector2(get_position().x,get_position().y + 2))
		if face.x < 0: shootarrow.direction = 180
		else: shootarrow.direction = 0
	get_tree().get_root().add_child(shootarrow)
	$TimerShoot.start()
	
func use_potion():
	$SoundPotion.play(0)
	$PartsPotion.set_emitting(true)
	controller.player_health = clamp(controller.player_health + 4, 0, 10)

func footstep_increment(delta):
	if state == WALK:
		if motion.x != 0 or motion.y != 0:
			sound += controller.convert_to_seconds(1, delta)
	
func footstep_sound():
	if sound != -1 and int(ceil(sound)) % 21 == 0 and state == WALK:
		sound = 0
		$SoundFootstep.play(0)
		
func stop_animation():
	if $Sprite.get_animation() in ["swingleft","swingright","shootleft","shootright","swingup", "swingdown", "shootup", "shootdown"]:
		if $Sprite.get_frame() >= 2:
			$Sprite.stop()
			
func deal_damage():
	var hitting = areaU.get_overlapping_bodies() + areaD.get_overlapping_bodies() + areaL.get_overlapping_bodies() + areaR.get_overlapping_bodies()
	for node in hitting:
		if node.is_in_group("Enemies") and not node.iframes and not node.dead: # Enemy
			$SoundDealDamage.play(0)
			var dir = (node.get_position() - get_position()).normalized()
			match state:
				DASH:
					node.deal_damage_knockback(dir)
				_:
					node.deal_damage_weak_knockback(dir)
		if node.is_in_group("OrbSwitch") and node.allow_sword and not node.pressed: # Orb switch
			node.press()
		if node.is_in_group("SentryShot") and not node.fade:
			$SoundDealDamage.play(0)
			node.fade = true
		if node.is_in_group("SesdinBoss") and not node.iframes:
			node.block()
		if node.is_in_group("BossEye") and not node.hit:
			node.deal_damage()
		if node.is_in_group("EndRegistry"):
			controller.bad_ending = true
			controller.corrupted_cells_add.append("00")
			controller.scene_change("res://Scenes/GATE/Gate-BadEnd1.tscn")
			hide()
	
# ================================================================================== TIMERS
	
func _on_TimerSwing_timeout():
	if state != NO_INPUT:
		state = WALK
	if face.y == -1: hbU.set_disabled(true)
	elif face.y == 1: hbD.set_disabled(true)
	elif face.x == -1: hbL.set_disabled(true)
	elif face.x == 1: hbR.set_disabled(true)

func _on_TimerSwingAnim_timeout():
	if state != DASH:
		if face.y < 0: $Sprite.play("up")
		elif face.y > 0: $Sprite.play("down")
		elif face.x < 0: $Sprite.play("left")
		elif face.x > 0: $Sprite.play("right")

func _on_TimerDash_timeout():
	if state != NO_INPUT:
		state = WALK
	if face.y < 0:
		$Sprite.play("up")
		hbU.set_disabled(true)
	elif face.y > 0:
		$Sprite.play("down")
		hbD.set_disabled(true)
	elif face.x < 0:
		$Sprite.play("left")
		hbL.set_disabled(true)
	elif face.x > 0:
		$Sprite.play("right")
		hbR.set_disabled(true)
	motion = Vector2(0,0)
	sound = -1

func _on_TimerShoot_timeout():
	if state != NO_INPUT:
		state = WALK
	if face.y < 0: $Sprite.play("up")
	elif face.y > 0: $Sprite.play("down")
	elif face.x < 0: $Sprite.play("left")
	elif face.x > 0: $Sprite.play("right")
	sound = -1

func _on_TimerWarp_timeout():
	warp = false
	
func _on_TimerIFrames_timeout():
	iframes = false

func _on_TimerBadEnding_timeout():
	controller.scene_change("res://Scenes/GATE/Gate-BadEnd2.tscn")
	hide()

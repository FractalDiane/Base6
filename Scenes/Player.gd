extends KinematicBody2D

var motion = Vector2(0,0)
var dash = Vector2(0,0)
var sound = -1
var warp = false

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

const WALK = 0
const SWING = 1
const DASH = 2
const SHOOT = 3
const DIALOGUE = 4
const MENU = 5
const NO_INPUT = 6
var state = WALK

# ================================================================================== STATES

func _ready():
	hide()

func _physics_process(delta):
	# Depth correction
	set_z_index(get_position().y)
	# Color shift for corruption animation
	color = clamp(color + 0.008,0,1)
	set_modulate(Color(color,color,color))
	
	# Move sight
	if $Sprite.get_animation() in ["up","walkup","swingup", "shootup"]:
		sight.set_position(Vector2(0,-10))
		sight.set_rotation_degrees(0)
	elif $Sprite.get_animation() in ["down","walkdown", "swingdown", "shootdown"]:
		sight.set_position(Vector2(0,20))
		sight.set_rotation_degrees(0)
	elif $Sprite.get_animation() in ["left","walkleft","swingleft","shootleft"]:
		sight.set_position(Vector2(-15,5))
		sight.set_rotation_degrees(90)
	elif $Sprite.get_animation() in ["right","walkright","swingright","shootright"]:
		sight.set_position(Vector2(15,5))
		sight.set_rotation_degrees(90)
	
	# Handle current state
	if state == WALK:
		state_walk()
	elif state == SWING:
		state_swing()
	elif state == DASH:
		state_dash()
	elif state == SHOOT:
		state_shoot()
	elif state == DIALOGUE:
		state_dialogue()
	elif state == MENU:
		state_menu()
		
	deal_damage()
	
	footstep_increment()
	footstep_sound()
	move_and_slide(motion)
	
func state_walk():
	# Movement
	if Input.is_action_pressed("ui_up"):
		if not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			$Sprite.play("walkup")
		motion.y = -80
		
	elif Input.is_action_pressed("ui_down"):
		if not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			$Sprite.play("walkdown")
		motion.y = 80
	else:
		motion.y = 0

	if Input.is_action_pressed("ui_left"):
		if not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down"):
			$Sprite.play("walkleft")
		motion.x = -80
	elif Input.is_action_pressed("ui_right"):
		if not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down"):
			$Sprite.play("walkright")
		motion.x = 80
	else:
		motion.x = 0
		
	# Stop corner animations from not playing
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"):
		if $Sprite.get_animation() == "left":
			$Sprite.set_animation("walkleft")
		elif $Sprite.get_animation() == "up":
			$Sprite.set_animation("walkup")
		else:
			$Sprite.set_animation("walkleft")
			
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"):
		if $Sprite.get_animation() == "right":
			$Sprite.set_animation("walkright")
		elif $Sprite.get_animation() == "up":
			$Sprite.set_animation("walkup")
		else:
			$Sprite.set_animation("walkright")
			
	if Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"):
		if $Sprite.get_animation() == "left":
			$Sprite.set_animation("walkleft")
		elif $Sprite.get_animation() == "down":
			$Sprite.set_animation("walkdown")
		else:
			$Sprite.set_animation("walkleft")
			
	if Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
		if $Sprite.get_animation() == "right":
			$Sprite.set_animation("walkright")
		elif $Sprite.get_animation() == "down":
			$Sprite.set_animation("walkdown")
		else:
			$Sprite.set_animation("walkright")
	
	# Stop footsteps
	if Input.is_action_just_released("ui_up") and not Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		$Sprite.play("up")
		sound = -1
	if Input.is_action_just_released("ui_down") and not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		$Sprite.play("down")
		sound = -1
	if Input.is_action_just_released("ui_left") and not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_right"):
		$Sprite.play("left")
		sound = -1
	if Input.is_action_just_released("ui_right") and not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_left"):
		$Sprite.play("right")
		sound = -1
	
	# SWING
	if Input.is_action_just_pressed("ui_attack"):
		state = SWING
		swing_attack()
		
	# DASH
	if Input.is_action_just_pressed("ui_dash"):
		state = DASH
		dash_attack()
		
	if Input.is_action_just_pressed("ui_shoot"):
		state = SHOOT
		shoot_bow()
		
	var current_sight = sight.get_overlapping_bodies()
	
	for node in current_sight:
		if node.is_in_group("NPC"):
			node.show_interact = true
			node.get_node("TimerHideInteract").start()
		
func state_swing():
	stop_animation()

func state_dash():
	stop_animation()
	
	# Decrease velocity after dash
	if motion.x < 0: # Left
		motion.x = clamp(motion.x + 6,-200,0)
	elif motion.x > 0: # Right
		motion.x = clamp(motion.x - 6,0,200)

	if motion.y < 0: # Up
		motion.y = clamp(motion.y + 6,-200,0)
	elif motion.y > 0: # Down
		motion.y = clamp(motion.y - 6,0,200)
	
func state_shoot():
	stop_animation()
	
func state_dialogue():
	pass
	
func state_menu():
	pass

# ================================================================================== LOCALS

func swing_attack():
	$SoundSwing.play(0)
	$SoundSwing.set_pitch_scale(rand_range(1,1.2))
	$Sprite.set_frame(0)
	if $Sprite.get_animation() in ["up","walkup","swingup"]:
		$Sprite.play("swingup")
		hbU.set_disabled(false)
		motion.x = 0
		motion.y = 0
	elif $Sprite.get_animation() in ["down","walkdown","swingdown"]:
		$Sprite.play("swingdown")
		hbD.set_disabled(false)
		motion.x = 0
		motion.y = 0
	elif $Sprite.get_animation() in ["left","walkleft","swingleft"]:
		$Sprite.play("swingleft")
		hbL.set_disabled(false)
		motion.x = 0
		motion.y = 0
	elif $Sprite.get_animation() in ["right","walkright","swingright"]:
		$Sprite.play("swingright")
		hbR.set_disabled(false)
		motion.x = 0
		motion.y = 0
	$TimerSwing.start()
	$TimerSwingAnim.start()
	
func dash_attack():
	$SoundSwing.play(0)
	$SoundSwing.set_pitch_scale(rand_range(0.75,0.9))
	$Sprite.set_frame(0)
	if $Sprite.get_animation() in ["up","walkup","swingup"]:
		motion.y = -250
		$Sprite.play("swingup")
		hbU.set_disabled(false)
	elif $Sprite.get_animation() in ["down","walkdown", "swingdown"]:
		motion.y = 250
		$Sprite.play("swingdown")
		hbD.set_disabled(false)
	elif $Sprite.get_animation() in ["left","walkleft","swingleft"]:
		motion.x = -250
		$Sprite.play("swingleft")
		hbL.set_disabled(false)
	elif $Sprite.get_animation() in ["right","walkright","swingright"]:
		motion.x = 250
		$Sprite.play("swingright")
		hbR.set_disabled(false)
	$TimerDash.start()
	
func shoot_bow():
	$SoundShoot.play(0)
	$Sprite.set_frame(0)
	var shootarrow = arrow.instance()
	if $Sprite.get_animation() in ["up","walkup","swingup"]:
		$Sprite.play("shootup")
		motion.x = 0
		motion.y = 0
		shootarrow.set_position(Vector2(get_position().x,get_position().y - 1))
		shootarrow.direction = 90
	elif $Sprite.get_animation() in ["down","walkdown","swingdown"]:
		$Sprite.play("shootdown")
		motion.x = 0
		motion.y = 0
		shootarrow.set_position(Vector2(get_position().x,get_position().y + 1))
		shootarrow.direction = 270
	elif $Sprite.get_animation() in ["left","walkleft","swingleft"]:
		$Sprite.play("shootleft")
		motion.x = 0
		motion.y = 0
		shootarrow.set_position(Vector2(get_position().x,get_position().y + 2))
		shootarrow.direction = 180
	elif $Sprite.get_animation() in ["right","walkright","swingright"]:
		$Sprite.play("shootright")
		motion.x = 0
		motion.y = 0
		shootarrow.set_position(Vector2(get_position().x,get_position().y + 2))
		shootarrow.direction = 0
	get_tree().get_root().add_child(shootarrow)
	$TimerShoot.start()

func footstep_increment():
	if state == WALK:
		if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			sound += 1
	
func footstep_sound():
	if sound != -1 and sound % 20 == 0 and state == WALK:
		$SoundFootstep.play(0)
		
func stop_animation():
	if $Sprite.get_animation() in ["swingleft","swingright","shootleft","shootright","swingup", "swingdown", "shootup", "shootdown"]:
		if $Sprite.get_frame() >= 2:
			$Sprite.stop()
			
func deal_damage():
	var hitting = areaU.get_overlapping_bodies() + areaD.get_overlapping_bodies() + areaL.get_overlapping_bodies() + areaR.get_overlapping_bodies()
	for node in hitting:
		if node.is_in_group("Enemies") and not node.iframes and not node.dead:
			$SoundDealDamage.play(0)
			node.deal_damage()
	
# ================================================================================== TIMERS
	
func _on_TimerSwing_timeout():
	state = WALK
	if $Sprite.get_animation() == "swingup":
		hbU.set_disabled(true)
	elif $Sprite.get_animation() == "swingdown":
		hbD.set_disabled(true)
	elif $Sprite.get_animation() == "swingleft":
		hbL.set_disabled(true)
	elif $Sprite.get_animation() == "swingright":
		hbR.set_disabled(true)

func _on_TimerSwingAnim_timeout():
	if state != DASH:
		if $Sprite.get_animation() == "swingup":
			$Sprite.play("up")
		elif $Sprite.get_animation() == "swingdown":
			$Sprite.play("down")
		elif $Sprite.get_animation() == "swingleft":
			$Sprite.play("left")
		elif $Sprite.get_animation() == "swingright":
			$Sprite.play("right")

func _on_TimerDash_timeout():
	state = WALK
	if $Sprite.get_animation() == "swingup":
		$Sprite.play("up")
		hbU.set_disabled(true)
	elif $Sprite.get_animation() == "swingdown":
		$Sprite.play("down")
		hbD.set_disabled(true)
	elif $Sprite.get_animation() == "swingleft":
		$Sprite.play("left")
		hbL.set_disabled(true)
	elif $Sprite.get_animation() == "swingright":
		$Sprite.play("right")
		hbR.set_disabled(true)
	sound = -1

func _on_TimerShoot_timeout():
	state = WALK
	if $Sprite.get_animation() == "shootup":
		$Sprite.play("up")
	elif $Sprite.get_animation() == "shootdown":
		$Sprite.play("down")
	elif $Sprite.get_animation() == "shootleft":
		$Sprite.play("left")
	elif $Sprite.get_animation() == "shootright":
		$Sprite.play("right")
	sound = -1

func _on_TimerWarp_timeout():
	warp = false

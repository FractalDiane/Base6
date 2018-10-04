extends KinematicBody2D

var motion = Vector2(0,0)
var dash = Vector2(0,0)
var swing = false
var dashing = false
var sound = -1

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	# Depth correction
	set_z_index(get_position().y)
	
	# Movement
	if not swing and not dashing:
		if Input.is_action_pressed("ui_up"):
			motion.y = -80
			$Sprite.play("walkup")
		elif Input.is_action_pressed("ui_down"):
			motion.y = 80
			$Sprite.play("walkdown")
		else:
			motion.y = 0
			
		if Input.is_action_pressed("ui_left"):
			motion.x = -80
			$Sprite.play("walkleft")
		elif Input.is_action_pressed("ui_right"):
			motion.x = 80
			$Sprite.play("walkright")
		else:
			motion.x = 0
	
	if not swing and not dashing:
		if Input.is_action_just_released("ui_up"):
			$Sprite.play("up")
			sound = -1
		if Input.is_action_just_released("ui_down"):
			$Sprite.play("down")
			sound = -1
		if Input.is_action_just_released("ui_left"):
			$Sprite.play("left")
			sound = -1
		if Input.is_action_just_released("ui_right"):
			$Sprite.play("right")
			sound = -1
		
	# Combat
	if Input.is_action_just_pressed("ui_accept") and not swing and not dashing: # Basic swing
		$SoundSwing.play(0)
		$SoundSwing.set_pitch_scale(rand_range(1,1.2))
		$Sprite.set_frame(0)
		swing = true
		if $Sprite.get_animation() == "left" or $Sprite.get_animation() == "walkleft" or $Sprite.get_animation() == "swingleft":
			$Sprite.play("swingleft")
			motion.x = 0
		elif $Sprite.get_animation() == "right" or $Sprite.get_animation() == "walkright" or $Sprite.get_animation() == "swingright":
			$Sprite.play("swingright")
			motion.x = 0
		$TimerSwing.start()
		$TimerSwingAnim.start()
	
	if not swing and not dashing and Input.is_action_just_pressed("ui_dash"): # Dash attack
		$SoundSwing.play(0)
		$SoundSwing.set_pitch_scale(rand_range(0.75,0.9))
		$Sprite.set_frame(0)
		dashing = true
		if $Sprite.get_animation() == "up" or $Sprite.get_animation() == "walkup":
			motion.y = -250
		elif $Sprite.get_animation() == "down" or $Sprite.get_animation() == "walkdown":
			motion.y = 250
		elif $Sprite.get_animation() == "left" or $Sprite.get_animation() == "walkleft" or $Sprite.get_animation() == "swingleft":
			motion.x = -250
			$Sprite.set_animation("swingleft")
		elif $Sprite.get_animation() == "right" or $Sprite.get_animation() == "walkright" or $Sprite.get_animation() == "swingright":
			motion.x = 250
			$Sprite.set_animation("swingright")
		$TimerDash.start()
		
	# Animation
	if swing or dashing:
		if $Sprite.get_animation() == "swingleft" or $Sprite.get_animation() == "swingright":
			if $Sprite.get_frame() >= 2:
				$Sprite.stop()
	
	# Sound
	if not swing and not dashing:
		if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			sound += 1
	
	# Decrease velocity after dash
	if dashing:
		if motion.x < 0: # Left
			motion.x = clamp(motion.x + 6,-200,0)
		elif motion.x > 0: # Right
			motion.x = clamp(motion.x - 6,0,200)
			
		if motion.y < 0: # Up
			motion.y = clamp(motion.y + 6,-200,0)
		elif motion.y > 0: # Down
			motion.y = clamp(motion.y - 6,0,200)

	footstep_sound()
	move_and_slide(motion)
	
func footstep_sound():
	if sound != -1 and sound % 20 == 0 and not swing:
		$SoundFootstep.play(0)

func _on_TimerSwing_timeout():
	swing = false

func _on_TimerSwingAnim_timeout():
	if not dashing:
		if $Sprite.get_animation() == "swingleft":
			$Sprite.play("left")
		elif $Sprite.get_animation() == "swingright":
			$Sprite.play("right")


func _on_TimerDash_timeout():
	dashing = false
	if $Sprite.get_animation() == "swingleft":
		$Sprite.play("left")
	elif $Sprite.get_animation() == "swingright":
		$Sprite.play("right")
	sound = -1

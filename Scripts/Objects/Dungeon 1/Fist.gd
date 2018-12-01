extends KinematicBody2D

var active = false
var following = false
export(int) var speed = 50
var motion = Vector2(0, 0)
var timer
var fistOffset = 0
var damage = 1
var switches
var translateSpeed = .8
var phase2 = false
var phase3 = false
var can_orbit = false
var orbiting = false
var orbit_center = Vector2(0, 0)
var ideal_pos = Vector2(0, 0)
var orbit_radius = 0
var orbit_angle = 0

onready var idealY = 0
onready var player = Player

func _ready(): #Create a personal timer object in the ready event
	if controller.flag["dungeon1_complete"] == 1:
		queue_free()
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.set_wait_time(.3)
	timer.set_one_shot(true)

func _physics_process(delta):
	if active and following:
		if position.distance_to(player.get_position()) < 2: #If the fist is next to the player, initiate drop timer.
			following = false
			timer.start()
			return
		var angle = get_angle_to(player.get_position()) #Direct the fist toward the player.
		motion = Vector2(speed * cos(angle), speed * sin(angle))
	else:
		if orbiting:
			orbit()
			motion = (ideal_pos - position) * 16
		else:
			motion = Vector2(0, 0)
	if fistOffset - .0001 > idealY: #Move the fist sprite either up or down depending on current offset.
		idealY += translateSpeed * 2
	elif fistOffset + .0001 < idealY:
		idealY -= translateSpeed
	else:
		checkPhase()
	$FistSprite.offset.y = idealY
	set_z_index(get_position().y) #Set depth properly
	move_and_slide(motion) #Move the fist toward the player.

func _on_animation_finished():
	if $ShadowSprite.animation == "lift": 	#If done lifting, start following.
		following = true
	else: 									#If done dropping, deactivate and set the other fist active.
		if can_orbit:
			orbiting = true
			orbit_center = position
			orbit_angle = 0
			orbit_radius = 0
		var coll = $Hitbox.get_overlapping_bodies()
		$CollisionShape2D.set_disabled(false)
		$PartsSlam.set_emitting(true)
		$SoundSlam.play(0)
		$SoundSlam.set_pitch_scale(rand_range(0.9,1.05))
		if player in coll and not player.iframes:
			damage_player(damage)
		coll = $Hitbox.get_overlapping_areas()
		for i in switches.size():
			if switches[i] in coll:
				switches[i].activate()
		active = false
		get_parent().switch()

func _on_timer_timeout(): #When the timer finishes, drop.
	$ShadowSprite.play("drop")
	fistOffset = 0
	
func activate(): #Lift the fist.
	active = true
	orbiting = false
	$CollisionShape2D.set_disabled(true)
	$ShadowSprite.play("lift")
	fistOffset = -32
	switches = get_parent().switches

func deactivate(): #Use only at end of fight to completely disable.
	active = false
	orbiting = false
	timer.set_paused(true)
	set_physics_process(false)
	$CollisionShape2D.set_disabled(true)

func damage_player(amount):
	if player.state != player.NO_INPUT:
		controller.player_damage(amount)
		player.iframes = true
		player.get_node("TimerIFrames").start()

func checkPhase():
	if phase2:
		phase2()
		phase2 = false
	if phase3:
		phase3()
		phase3 = false

func orbit():
	if orbit_radius < 16:
		orbit_radius += .5
	orbit_angle += .1
	ideal_pos = Vector2(orbit_center.x + orbit_radius * cos(orbit_angle), orbit_center.y + orbit_radius * sin(orbit_angle))

func phase2():
	speed = 75
	timer.set_wait_time(.25)
	translateSpeed = 1
	$ShadowSprite.frames.set_animation_speed("lift", 21)
	$ShadowSprite.frames.set_animation_speed("drop", 37)

func phase3():
	can_orbit = true
	speed = 80
	damage = 2
	timer.set_wait_time(.2)
	translateSpeed = 1.6
	$ShadowSprite.frames.set_animation_speed("lift", 34)
	$ShadowSprite.frames.set_animation_speed("drop", 60)
	
func shatter():
	$SoundShatter.play(0)
	$PartsShatter.set_emitting(true)
	$FistSprite.hide()
	$ShadowSprite.hide()
	$TimerDie.start()

func _on_TimerDie_timeout():
	queue_free()

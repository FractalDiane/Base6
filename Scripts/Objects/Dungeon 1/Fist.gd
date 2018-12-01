extends KinematicBody2D

var active = false
var following = false
export(int) var speed = 50
var motion = Vector2(0, 0)
var timer
var waitTimer
var fistOffset = 0
var damage = 1
var switches
var translateSpeed = .5
var speedup = false
var orbit = false

onready var player = Player

func _ready(): #Create a personal timer object in the ready event
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.set_wait_time(.3)
	timer.set_one_shot(true)
	waitTimer = Timer.new()
	waitTimer.connect("timeout",self,"_on_waitTimer_timeout") 
	add_child(waitTimer)
	waitTimer.set_wait_time(.1)
	waitTimer.set_one_shot(true)

func _physics_process(delta):
	if active and following:
		if position.distance_to(player.get_position()) < 2: #If the fist is next to the player, initiate drop timer.
			following = false
			timer.start()
			return
		var angle = get_angle_to(player.get_position()) #Direct the fist toward the player.
		motion = Vector2(speed * cos(angle), speed * sin(angle))
	else:
		motion = Vector2(0, 0)
	if fistOffset > $FistSprite.position.y - 6: #Move the fist sprite either up or down depending on current offset.
		$FistSprite.translate(Vector2(0, translateSpeed * 2))
	elif fistOffset < $FistSprite.position.y - 6:
		$FistSprite.translate(Vector2(0, -translateSpeed))
	set_z_index(get_position().y) #Set depth properly
	move_and_slide(motion) #Move the fist toward the player.

func _on_animation_finished():
	if speedup:
		speedup()
		speedup = false
	if $ShadowSprite.animation == "lift": 	#If done lifting, start following.
		following = true
	else: 									#If done dropping, deactivate and set the other fist active.
		var coll = $Hitbox.get_overlapping_bodies()
		$CollisionShape2D.set_disabled(false)
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
	$CollisionShape2D.set_disabled(true)
	$ShadowSprite.play("lift")
	fistOffset = -32
	switches = get_parent().switches

func deactivate(): #Use only at end of fight to completely disable.
	active = false
	timer.set_paused(true)

func damage_player(amount):
	controller.player_damage(amount)
	player.iframes = true
	player.get_node("TimerIFrames").start()

func speedup():
	speed = 60
	timer.set_wait_time(.2)
	translateSpeed = 1
	$ShadowSprite.frames.set_animation_speed("lift", 33)
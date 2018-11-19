extends KinematicBody2D

var active = false
var following = false
export(int) var speed = 50
var motion = Vector2(0, 0)
var timer
var fistOffset = 0

onready var player = Player

func _ready(): #Create a personal timer object in the ready event
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
		motion = Vector2(0, 0)
	if fistOffset > $FistSprite.position.y - 6: #Move the fist sprite either up or down depending on current offset.
		$FistSprite.translate(Vector2(0, 1.5))
	elif fistOffset < $FistSprite.position.y - 6:
		$FistSprite.translate(Vector2(0, -.5))
	set_z_index(get_position().y) #Set depth properly
	move_and_slide(motion) #Move the fist toward the player.

func _on_animation_finished():
	if $ShadowSprite.animation == "lift": 	#If done lifting, start following.
		following = true
	else: 									#If done dropping, deactivate and set the other fist active.
		active = false
		get_parent().switch()

func _on_timer_timeout(): #When the timer finishes, drop.
	$ShadowSprite.play("drop")
	fistOffset = 0
	
func activate(): #Lift the fist.
	active = true
	$ShadowSprite.play("lift")
	fistOffset = -30

func deactivate(): #Use only at end of fight to completely disable.
	active = false
	timer.set_paused(true)

extends Area2D

export(Vector2) var required_direction
export(int) var distance

onready var player = Player

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	var coll = get_overlapping_bodies()
	if player in coll and player.state == player.DASH and player.face == required_direction and not player.jumping:
		jump()
		
func jump():
	player.get_node("SoundJump").play(0)
	player.motion = get_jump_motion(required_direction)
	var time = 1.0 / (150.0 / distance)
	player.jumping = true
	player.get_node("TimerDash").stop()
	$TimerLand.set_wait_time(time)
	$TimerLand.start()
	
func get_jump_motion(required_direction):
	if required_direction == Vector2(0,-1): # Up
		return Vector2(0,-150)
	elif required_direction == Vector2(0,1): # Down
		return Vector2(0,150)
	elif required_direction == Vector2(-1,0): # Left
		return Vector2(-150,0)
	elif required_direction == Vector2(1,0): # Right
		return Vector2(150,0)
		

func _on_TimerLand_timeout():
	player.get_node("SoundLand").play(0)
	player.motion = Vector2(0,0)
	player.jumping = false
	player._on_TimerDash_timeout()

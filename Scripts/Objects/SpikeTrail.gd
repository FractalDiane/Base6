extends AnimatedSprite

var timer

onready var player = Player

func _ready():
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.set_wait_time(.2)
	timer.set_one_shot(true)
	play("Rise")

func _physics_process(delta):
	var coll = $Hitbox.get_overlapping_bodies()
	if player in coll and not player.iframes:
		damage_player(1)

func _on_animation_finished():
	if animation == "Rise": 	#If done lifting, start following.
		timer.start()
	else:
		queue_free()
		#get_parent().remove_child(self)

func _on_timer_timeout():
	play("Fall")

func damage_player(amount):
	if player.state != player.NO_INPUT:
		controller.player_damage(amount)
		player.iframes = true
		player.get_node("TimerIFrames").start()
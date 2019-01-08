extends StaticBody2D

var timer
var hit = false

func _ready():
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.set_wait_time(5)
	timer.set_one_shot(true)
	$AnimatedSprite.play("up")
	
func deal_damage():
	if not hit:
		if get_tree().get_root().get_node("Node2D").get_node("BossController").health > 1:
			$SoundHit.play(0)
			$SoundHit2.play(0)
		get_tree().get_root().get_node("Node2D").get_node("BossController").deal_damage()
		get_tree().get_root().get_node("Node2D").get_node("BossController").get_node("PartsDamage").set_position(get_position())
		get_tree().get_root().get_node("Node2D").get_node("BossController").get_node("PartsDamage").set_emitting(true)
		hit = true
		$AnimatedSprite.play("down")

func _on_timer_timeout():
	$AnimatedSprite.play("down")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "up":
		$AnimatedSprite.stop()
		timer.start()
	else:
		queue_free()

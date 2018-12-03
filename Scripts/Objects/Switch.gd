extends Area2D

export(bool) var one_shot = true
export(float) var time = 0
export(String) var target_flag = "null"
export(bool) var reemit_signal = false

signal on_pressed
signal on_released

var pressed = false

onready var player = Player

func _ready():
	if target_flag != "null" and controller.flag[target_flag] == 1:
		$Sprite.set_animation("down")
		if reemit_signal:
			$TimerReemitSignal.start()
		pressed = true

#func _physics_process(delta):
#	if not pressed:
#		var coll = get_overlapping_bodies()
#		for node in coll:
#			if node == player: #or node.is_in_group("Pushables"):
#				push()
#	elif not one_shot:
#		var coll = get_overlapping_bodies()
#		if not player in coll: # and not box in coll:
#			unpush()

func push():
	$SoundPressed.play(0)
	$Sprite.play("down")
	emit_signal("on_pressed")
	if target_flag != "null":
		controller.flag[target_flag] = 1
	pressed = true
	
func unpush():
	$SoundPressed.play(0)
	$Sprite.play("up")
	emit_signal("on_released")
	if target_flag != "null":
		controller.flag[target_flag] = 0
	pressed = false

func _on_TimerReemitSignal_timeout():
	emit_signal("on_pressed")

func _on_Switch_body_entered(body):
	if not pressed:
		if body == player and player.state != player.NO_INPUT:
			push()
		if body.is_in_group("Pushables"):
			push()

func _on_Switch_body_exited(body):
	if pressed and not one_shot:
		if body == player or body.is_in_group("Pushables"):
			unpush()

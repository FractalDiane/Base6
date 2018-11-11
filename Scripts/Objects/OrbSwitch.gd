extends StaticBody2D

export(bool) var one_shot = true
export(float) var time = 0
export(bool) var allow_bow = true
export(String) var target_flag = "null"
export(bool) var reemit_signal

signal on_trigger

var pressed = false

onready var player = Player

func _ready():
	if target_flag != "null" and controller.flag[target_flag] == 1:
		$Sprite.set_animation("on")
		if reemit_signal:
			$TimerReemitSignal.start()
		pressed = true

func press():
	$SoundPressed.play(0)
	$Sprite.set_animation("on")
	emit_signal("on_trigger")
	if target_flag != "null":
		controller.flag[target_flag] = 1
	pressed = true

func _on_TimerReemitSignal_timeout():
	emit_signal("on_trigger")

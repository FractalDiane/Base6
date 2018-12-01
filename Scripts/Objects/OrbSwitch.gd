extends StaticBody2D

export(bool) var one_shot = true
export(float) var time = 0
export(bool) var allow_bow = true
export(bool) var allow_sword = true
export(String) var target_flag = "null"
export(bool) var reemit_signal
export(bool) var is_boss = false

signal on_trigger
signal on_timeout

var pressed = false

onready var player = Player
onready var display = $TimerDisplay
onready var timer = $TimerTimeout

func _ready():
	if target_flag != "null" and controller.flag[target_flag] == 1:
		$Sprite.set_animation("on")
		if reemit_signal:
			$TimerReemitSignal.start()
		pressed = true
	if time == 0:
		display.queue_free()
	else:
		display.set_max(time)
		
func _physics_process(delta):
	if time > 0 and pressed:
		display.set_value(timer.get_time_left())

func press():
	if not pressed:
		$SoundPressed.play(0)
		if time == 0:
			if not is_boss:
				$Sprite.set_animation("on")
		emit_signal("on_trigger")
		if target_flag != "null":
			controller.flag[target_flag] = 1
		pressed = true
		if time > 0:
			display.set_value(time)
			$TimerTimeout.set_wait_time(time)
			$TimerTimeout.start()
			$SoundTimer.play(0)
			
func timeout():
	$SoundPressed.play(0)
	$SoundTimer.stop()
	$Sprite.set_animation("off")
	pressed = false

func _on_TimerReemitSignal_timeout():
	emit_signal("on_trigger")

func _on_TimerTimeout_timeout():
	emit_signal("on_timeout")
	timeout()

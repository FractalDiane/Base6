extends CanvasLayer

export(bool) var corrupt = true
export(float) var corrupt_interval = 5

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$TimerCorrupt.stop()
	$TimerCorrupt.set_wait_time(corrupt_interval)
	$TimerCorrupt.start()

func _on_TimerCorrupt_timeout():
	if corrupt:
		controller.player_corrupt(1)
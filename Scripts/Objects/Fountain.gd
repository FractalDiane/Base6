extends StaticBody2D

var corr = false

func _ready():
	if not corr:
		$TimerBlink.set_wait_time(round(rand_range(5,10)))
		$TimerBlink.start()
		
	if controller.flag["dungeon2_complete"] == 1:
		$Sprite.play("closed")
		$TimerBlink.stop()

func _on_TimerBlink_timeout():
	if not corr:
		$Sprite.play("blink")

func _on_Sprite_animation_finished():
	if not corr:
		if $Sprite.get_animation() == "blink":
			$Sprite.play("idle")
			$TimerBlink.set_wait_time(round(rand_range(5,10)))
			$TimerBlink.start()
	
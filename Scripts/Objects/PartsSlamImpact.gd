extends Particles2D

func _on_TimerDestroy_timeout():
	queue_free()

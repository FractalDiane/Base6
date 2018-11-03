extends Node2D

export(String, FILE, "*.tscn") var start_scene
export(Vector2) var start_position
export(Array, String) var flags

func _on_TimerGameStart_timeout():
	# Initialize flags in global game controller
	for key in flags:
		controller.flag[key] = 0
		
	controller.scene_change(start_scene)
	Player.set_position(start_position)
	Player.show()
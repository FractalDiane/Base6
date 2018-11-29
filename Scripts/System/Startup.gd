extends Node2D

export(String, FILE, "*.tscn") var start_scene
export(Vector2) var start_position
export(Array, String) var flags
export(bool) var title_screen = false

func _on_TimerGameStart_timeout():
	# Initialize flags in global game controller
	for key in flags:
		controller.flag[key] = 0
	
	if title_screen:
		controller.scene_change("res://Scenes/Title.tscn", false)
		Player.state = Player.NO_INPUT
	else:
		controller.scene_change(start_scene)
		Player.set_position(start_position)
		Player.show()
		Player.state = Player.WALK
		Player.face = Vector2(0,1)
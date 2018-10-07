extends Node2D

export(String, FILE, "*.tscn") var start_scene

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_TimerGameStart_timeout():
	controller.scene_change(start_scene)
	Player.set_position(Vector2(100,78))
	Player.show()
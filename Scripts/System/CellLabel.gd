extends Label

export(int) var cell_index_x = 0
export(int) var cell_index_y = 0
export(AudioStreamSample) var cell_music = "res://Sounds/Music/White Noise.wav"

func _ready():
	hide()
	
	if get_text() in controller.corrupted_cells_add:
		var corr = load("res://Instances/CorruptionOverlay.tscn")
		var corr_i = corr.instance()
		get_tree().get_root().get_node("Node2D").call_deferred("add_child", corr_i)
		cell_music = load("res://Sounds/Music/Red Noise.wav")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
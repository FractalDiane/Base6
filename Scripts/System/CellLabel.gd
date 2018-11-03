extends Label

export(int) var cell_index_x = 0
export(int) var cell_index_y = 0
export(AudioStreamSample) var cell_music = "res://Sounds/Music/White Noise.wav"

func _ready():
	hide()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
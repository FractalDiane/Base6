extends AudioStreamPlayer

var initial_volume
onready var my_stream = stream

func _ready():
	initial_volume = volume_db
	update_volume()

func update_volume():
	set_volume_db(initial_volume + controller.audio_music_volume)
	if volume_db < -60:
		stream = null
	elif stream == null:
		stream = my_stream
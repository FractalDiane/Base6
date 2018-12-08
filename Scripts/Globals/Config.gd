extends Node

var file

func _ready():
	load_file()
	controller.update_audio()

func load_file():
	file = ConfigFile.new()
	var result = file.load("user://settings.cfg")
	if result != OK:
		file.set_value("Audio", "music_volume", 100)
		file.set_value("Audio", "effects_volume", 100)
		file.save("user://settings.cfg")

func save():
	file.save("user://settings.cfg")
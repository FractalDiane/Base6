extends Node

var file

func _ready():
	load_file()
	if file.has_section_key("Display", "fullscreen"):
		OS.window_fullscreen = file.get_value("Display", "fullscreen", false)
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
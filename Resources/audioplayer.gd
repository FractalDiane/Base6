extends Node

var main = null
var current_music = null

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#func _ready():

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func update_music():
	main = get_parent().get_node("Node2D")
	if main.get_node("CellLabel").get_text() != "ST":
		var new_music = main.get_node("CellLabel").cell_music
		if current_music == null:
			$Music.set_stream(main.get_node("CellLabel").cell_music)
			play_sound("Music")
			current_music = new_music
		else:
			if current_music != new_music:
				$Music.set_stream(main.get_node("CellLabel").cell_music)
				play_sound("Music")
				current_music = new_music

func play_sound(sound):
	get_node(sound).play(0)
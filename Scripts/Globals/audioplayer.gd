extends Node

var main = null
var current_music = null

onready var hum = $SoundHum
onready var cont = controller

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#func _ready():

func _physics_process(delta):
	if cont.player_corruption > 0 and cont.player_corruption < 100:
		if not hum.is_playing():
			hum.play(0)
		if cont.player_corruption <= 5:
			hum.set_volume_db(-46 + (3 * cont.player_corruption))
		else:
			hum.set_volume_db(-46 + (3.5 * cont.player_corruption))

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
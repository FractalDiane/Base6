extends CanvasLayer

var pos_x = 1
var pos_y = 1

var color = 0.8
var t = 0
var test = 0

onready var mapmarker = get_node("Map").get_node("MapMarkerSprite")

func _ready():
	# Get current cell for minimap
	if get_parent().get_node("CellLabel").cell_index_x != -1:
		pos_x += (2 * get_parent().get_node("CellLabel").cell_index_x)
		pos_y += (2 * get_parent().get_node("CellLabel").cell_index_y)
	else:
		pos_x = 20
		pos_y = 2
	mapmarker.set_position(Vector2(pos_x,pos_y))

func _physics_process(delta):
	t += 1
	color = controller.wave(0.2, 0.8, 0.5, 0, t, delta)
	mapmarker.set_modulate(Color(color, color, color))
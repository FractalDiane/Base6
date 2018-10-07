extends CanvasLayer

var pos_x = 1
var pos_y = 1

func _ready():
	# Get current cell for HUD
	if get_parent().get_node("CellLabel").cell_index_x != -1:
		pos_x += (2 * get_parent().get_node("CellLabel").cell_index_x)
		pos_y += (2 * get_parent().get_node("CellLabel").cell_index_y)
	else:
		pos_x = 20
		pos_y = 2
	get_node("Map").get_node("MapMarkerSprite").set_position(Vector2(pos_x,pos_y))

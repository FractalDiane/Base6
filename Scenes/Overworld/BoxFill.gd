extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	update()
	
func _draw():
	var x1 = get_parent().box_x
	var y1 = get_parent().box_y
	var w = get_parent().ww
	var h = get_parent().hh
	
	draw_rect(Rect2(x1 + 5, y1 + 5, w - 10, h - 10), Color(1,1,1))
extends Node2D

onready var parent = get_parent()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	update()
	
func _draw():
	var x1 = parent.box_x
	var y1 = parent.box_y
	var w = parent.ww
	var h = parent.hh
	
	draw_rect(Rect2(x1 + 5, y1 + 5, w - 10, h - 10), Color(1,1,1))
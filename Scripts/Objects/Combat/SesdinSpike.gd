extends Area2D

var sc = 0

onready var spr = $Sprite

func _ready():
	pass

func _physics_process(delta):
	sc = clamp(sc + 0.05,0,1)
	spr.set_scale(Vector2(sc,sc))

func _on_TimerActivate_timeout():
	pass # replace with function body

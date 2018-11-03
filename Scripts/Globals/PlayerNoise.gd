extends CanvasLayer

onready var cont = controller
onready var spr1 = $Sprite
onready var spr2 = $Sprite2
onready var spr3 = $Sprite3

var alpha = 0

func _ready():
	spr1.set_frame(0)
	spr2.set_frame(0)
	spr3.set_frame(0)

func _physics_process(delta):
	alpha = 0.1 * cont.player_corruption
	spr1.set_self_modulate(Color(1,1,1,alpha * 0.8))
	spr2.set_self_modulate(Color(1,1,1,alpha * 0.8))
	spr3.set_self_modulate(Color(1,1,1,alpha * 0.8))
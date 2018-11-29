extends CanvasLayer

var alpha = 1
var fade = false

var reset_state = true

onready var spr = $Sprite

func _ready():
	pass

func _physics_process(delta):
	if fade:
		alpha = clamp(alpha - 0.06,0,1)
		
	spr.set_modulate(Color(1, 1, 1, alpha))

#func _on_TimerStopFade_timeout():
	

func _on_TimerRestart_timeout():
	fade = false
	spr.texture = null
	alpha = 1
	
	if reset_state:
		Player.state = Player.WALK

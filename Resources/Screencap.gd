extends Sprite

var alpha = 1
var fade = false

func _ready():
	pass

func _physics_process(delta):
	if fade:
		alpha = clamp(alpha - 0.06,0,1)
		
	set_modulate(Color(1, 1, 1, alpha))

func _on_TimerStopFade_timeout():
	fade = false
	texture = null
	alpha = 1
	
	Player.state = Player.WALK
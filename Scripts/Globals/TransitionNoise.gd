extends CanvasLayer

var active = false
var alpha = 0
var fading = false

var noise = []

func _ready():
	noise.append(get_node("Noise"))
	noise.append(get_node("Noise2"))
	noise.append(get_node("Noise3"))
	noise.append(get_node("Noise4"))
	noise.append(get_node("Noise5"))
	noise.append(get_node("Noise6"))
	noise.append(get_node("Noise7"))
	noise.append(get_node("Noise8"))
	noise.append(get_node("Noise9"))
	noise.append(get_node("Noise10"))
	noise.append(get_node("Noise11"))
	noise.append(get_node("Noise12"))
	noise.append(get_node("Noise13"))
	noise.append(get_node("Noise14"))
	noise.append(get_node("Noise15"))
	noise.append(get_node("Noise16"))
	noise.append(get_node("Noise17"))
	noise.append(get_node("Noise18"))

func _physics_process(delta):
	if active:
		alpha = 1
	else:
		alpha = clamp(alpha - controller.convert_to_seconds(0.006, delta),0,1)
		
	for node in noise:
		node.set_modulate(Color(1,1,1,alpha))
		
	if alpha <= 0 and fading:
		audioplayer.init = false
		Player.state = Player.WALK
		fading = false
		active = false

func _on_TimerActive_timeout():
	active = false
	fading = true
	audioplayer.fade_noise = true

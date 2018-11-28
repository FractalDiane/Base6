extends Node2D

var noise_alpha = 0
var noise = false

var spr = []

func _ready():
	spr.append(get_node("Noise"))
	spr.append(get_node("Noise2"))
	spr.append(get_node("Noise3"))
	spr.append(get_node("Noise4"))
	spr.append(get_node("Noise5"))
	spr.append(get_node("Noise6"))
	spr.append(get_node("Noise7"))
	spr.append(get_node("Noise8"))
	spr.append(get_node("Noise9"))
	spr.append(get_node("Noise10"))
	spr.append(get_node("Noise11"))
	spr.append(get_node("Noise12"))
	spr.append(get_node("Noise13"))
	spr.append(get_node("Noise14"))
	spr.append(get_node("Noise15"))
	spr.append(get_node("Noise16"))
	spr.append(get_node("Noise17"))
	spr.append(get_node("Noise18"))
	
	$SoundGameOver.play(0)

func _physics_process(delta):
	Player.state = Player.NO_INPUT
	Player.motion = Vector2(0,0)
	
	if noise:
		noise_alpha = clamp(noise_alpha + 0.006,0,1)
		
	for node in spr:
		node.set_modulate(Color(1,1,1,noise_alpha))


func _on_TimerNoise_timeout():
	noise = true
	$SoundNoise.play(0)
	$TimerEnd.start()

func _on_TimerEnd_timeout():
	get_tree().quit()

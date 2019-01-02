extends Node2D

var spr = []
var noise = false
var noise_alpha = 0

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
	
func _physics_process(delta):
	Player.state = Player.NO_INPUT
	Player.motion = Vector2(0,0)
	
	if noise:
		noise_alpha = clamp(noise_alpha + 0.006,0,1)
		
	for node in spr:
		node.set_modulate(Color(1,1,1,noise_alpha))

func _on_Timer1_timeout():
	$Music.play(0)
	$Logo.show()

func _on_Timer2_timeout():
	$Music.play(0)
	$Logo.hide()
	$Credits1a.show()
	$Credits1b.show()

func _on_Timer3_timeout():
	$Music.play(0)
	$Credits1a.hide()
	$Credits1b.hide()
	$Credits2a.show()
	$Credits2b.show()

func _on_Timer4_timeout():
	$Music.play(0)
	$Credits2a.hide()
	$Credits2b.hide()
	$Credits3a.show()
	$Credits3b.show()

func _on_Timer5_timeout():
	$Music.play(0)
	$Credits3a.hide()
	$Credits3b.hide()
	$Credits4a.show()
	$Credits4b.show()

func _on_Timer6_timeout():
	$Music.play(0)
	$Credits4a.hide()
	$Credits4b.hide()

func _on_Timer7_timeout():
	$SoundNoise.play(0)
	noise = true
	$TimerEnd.start()

func _on_TimerEnd_timeout():
	get_tree().quit()

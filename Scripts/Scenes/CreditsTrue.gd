extends Node2D

var spr = []
var noise = false
var noise_alpha = 0
var fade_alpha = 1
var fade_dir = 1
var rate = 0.01
var end = false

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
	
	fade_alpha = clamp(fade_alpha + (rate * delta * 60 * fade_dir), 0, 1)
	if not end:
		$ColorRect2.set_modulate(Color(1,1,1,fade_alpha))
	else:
		$ColorRect2.set_modulate(Color(0,0,0,fade_alpha))
	
	if noise:
		noise_alpha = clamp(noise_alpha + 0.006,0,1)
		
	for node in spr:
		node.set_modulate(Color(1,1,1,noise_alpha))
		
func swap_fade():
	fade_dir *= -1

func _on_Timer1_timeout():
	$Music.play(0)

func _on_Timer2_timeout():
	$Logo.show()
	swap_fade()

func _on_Timer3_timeout():
	swap_fade()

func _on_Timer4_timeout():
	$Logo.hide()
	$Credits1a.show()
	$Credits1b.show()
	swap_fade()

func _on_Timer5_timeout():
	swap_fade()

func _on_Timer6_timeout():
	$Credits1a.hide()
	$Credits1b.hide()
	$Credits2a.show()
	$Credits2b.show()
	swap_fade()

func _on_Timer7_timeout():
	swap_fade()

func _on_Timer8_timeout():
	$Credits2a.hide()
	$Credits2b.hide()
	$Credits3a.show()
	$Credits3b.show()
	swap_fade()

func _on_Timer9_timeout():
	swap_fade()

func _on_Timer10_timeout():
	$Credits3a.hide()
	$Credits3b.hide()
	$Credits4a.show()
	$Credits4b.show()
	swap_fade()

func _on_Timer11_timeout():
	swap_fade()

func _on_Timer12_timeout():
	rate = 0.005
	$Credits4a.hide()
	$Credits4b.hide()
	$GroupShot.show()
	$THEEND.show()
	swap_fade()

func _on_Timer13_timeout():
	end = true
	swap_fade()

func _on_TimerEnd_timeout():
	get_tree().quit()

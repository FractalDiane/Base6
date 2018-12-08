extends Node2D

var logo_alpha = 0
var logo_speed = 0
var logo_acc = 1
var logo_active = false

var options = []
var options_alpha = 0
var options_speed = 1.2
var options_acc = 1
var options_active = false

var boxes = {}
var boxes_alpha = 0
var boxes_active = false

var cursor = 0
var selected = false

var credits_t = 0.0
var credits_stage = -1
var roll_credits = false
var credits_actives = [false]
var credits_accs = [1,1,1,1,1,1,1,1,1,1,1,1,1]
var credits_alphas = [0,0,0,0,0,0,0,0,0,0,0,0,0]
var credits_cancel = false

var go_to_settings = false
var settings_state = 0
var settings_alpha = 0

var transition_acc = 1
var transition_active = false

onready var logo = $Logo
onready var wipe = $Transition
onready var credits = $CreditsGroup
onready var box3 = $Box3

func _ready():
	Player.state = Player.NO_INPUT
	$Transition.hide()
	
	logo.set_modulate(Color(1,1,1,0))
	logo.position.y -= 40
	options.append(get_node("START"))
	options.append(get_node("OPTIONS"))
	options.append(get_node("CREDITS"))
	options.append(get_node("EXIT"))
	
	for op in options:
		op.set_modulate(Color(1,1,1,0))
		op.margin_top += 40
		
	boxes[0] = get_node("Box1")
	boxes[1] = get_node("Box2")
	boxes[2] = get_node("Box3")
	boxes[3] = get_node("Box4")
	
	for box in boxes:
		boxes[box].set_modulate(Color(1,1,1,0))
		
	credits_actives.resize(13)
	for val in credits_actives:
		val = false
		
	for node in credits.get_children():
		node.margin_left -= 100
	
	$"OptionsGroup/Music Slider".value = controller.audio_music_percent
	$"OptionsGroup/Effects Slider".value = controller.audio_effects_percent
	
func _physics_process(delta):
	if logo_active:
		logo_acc = clamp(logo_acc - controller.convert_to_seconds(0.0185, delta),0,1)
		logo_alpha = clamp(logo_alpha + controller.convert_to_seconds(0.025, delta),0,1)
		
		logo.position.y = min(logo.position.y + (controller.convert_to_seconds(logo_speed * logo_acc, delta)), 58)
		logo.set_modulate(Color(1,1,1,logo_alpha))
	else:
		logo_acc = clamp(logo_acc + controller.convert_to_seconds(0.0185, delta),0,1)
		logo_alpha = clamp(logo_alpha - controller.convert_to_seconds(0.025, delta),0,1)
		
		logo.position.y = max(logo.position.y - (controller.convert_to_seconds(logo_speed * logo_acc, delta)), 18)
		logo.set_modulate(Color(1,1,1,logo_alpha))
		
	if options_active:
		options_acc = clamp(options_acc - controller.convert_to_seconds(0.015, delta),0,1)
		options_alpha = clamp(options_alpha + controller.convert_to_seconds(0.025, delta),0,1)
		
		for op in options:
			op.margin_top = max(op.margin_top - (controller.convert_to_seconds(options_speed * options_acc, delta)),82 + 11 * options.find(op))
			op.set_modulate(Color(1,1,1,options_alpha))
	else:
		options_acc = clamp(options_acc + controller.convert_to_seconds(0.015, delta),0,1)
		options_alpha = clamp(options_alpha - controller.convert_to_seconds(0.025, delta),0,1)
		
		for op in options:
			op.margin_top = min(op.margin_top + (controller.convert_to_seconds(options_speed * options_acc, delta)),122 + 11 * options.find(op))
			op.set_modulate(Color(1,1,1,options_alpha))
			
	if boxes_active:
		if not boxes[cursor].is_visible():
			boxes[cursor].show()
		boxes_alpha = clamp(boxes_alpha + 0.025,0,1)
		for box in boxes:
			if box == cursor:
				boxes[box].set_modulate(Color(1,1,1,boxes_alpha))
			else:
				boxes[box].set_modulate(Color(1,1,1,0))
			
		if selected:
			boxes[cursor].scale.x += controller.convert_to_seconds(0.1, delta)
			boxes[cursor].scale.y -= controller.convert_to_seconds(0.1, delta)
			if boxes[cursor].scale.y <= 0:
				boxes[cursor].hide()
				boxes_active = false
				
	if roll_credits:
		credits_t += controller.convert_to_seconds(1, delta)
		if int(credits_t) % 6 == 0:
			credits_stage += 1
		for node in credits.get_children():
			var i = credits.get_children().find(node)
			if credits_stage >= i:
				credits_actives[i] = true
				
		for node in credits.get_children():
			var i = credits.get_children().find(node)
			if credits_actives[i]:
				credits_alphas[i] = clamp(credits_alphas[i] + controller.convert_to_seconds(0.03, delta),0,1)
				credits_accs[i] = clamp(credits_accs[i] - controller.convert_to_seconds(0.02, delta),0,1)
				
				credits.get_child(i).margin_left += controller.convert_to_seconds(4 * credits_accs[i], delta)
				credits.get_child(i).set_modulate(Color(1,1,1,credits_alphas[i]))
	else:
		credits_t += controller.convert_to_seconds(1, delta)
		if int(credits_t) % 6 == 0:
			credits_stage += 1
		for node in credits.get_children():
			var i = credits.get_children().find(node)
			if credits_stage >= i:
				credits_actives[i] = false

		for node in credits.get_children():
			var i = credits.get_children().find(node)
			if not credits_actives[i]:
				credits_alphas[i] = clamp(credits_alphas[i] - controller.convert_to_seconds(0.03, delta),0,1)
				credits_accs[i] = clamp(credits_accs[i] + controller.convert_to_seconds(0.02, delta),0,1)

				credits.get_child(i).margin_left = max(credits.get_child(i).margin_left - controller.convert_to_seconds(4 * credits_accs[i], delta),-95)
				credits.get_child(i).set_modulate(Color(1,1,1,credits_alphas[i]))
	
	if go_to_settings:
		match settings_state:
			0:
				for node in $OptionsGroup.get_children():
					settings_alpha += delta
					if settings_alpha < 1:
						node.set_modulate(Color(0, 0, 0, settings_alpha))
					else:
						node.set_modulate(Color(0, 0, 0, 1))
				if settings_alpha >= 1:
					settings_state = 1
			1:
				pass
			2:
				for node in $OptionsGroup.get_children():
					settings_alpha -= delta
					if settings_alpha > 0:
						node.set_modulate(Color(0, 0, 0, settings_alpha))
					else:
						node.set_modulate(Color(0, 0, 0, 0))
				if settings_alpha <= 0:
					settings_state = 0
					go_to_settings = false
					$"OptionsGroup/Music Slider".visible = false
					$"OptionsGroup/Effects Slider".visible = false
					for node in $OptionsGroup.get_children():
						node.set_modulate(Color(1, 1, 1, 0))
					$TimerShowStuff.start()
					Config.file.set_value("Audio", "music_volume", controller.audio_music_percent)
					Config.file.set_value("Audio", "effects_volume", controller.audio_effects_percent)
					Config.save()
				
		
	input()
		
	if transition_active:
		transition_acc = clamp(transition_acc - controller.convert_to_seconds(0.0115, delta),0,1)
		wipe.scale.x += controller.convert_to_seconds((0.375 * transition_acc), delta)
		
func input():
	if not selected and boxes_active:
		if Input.is_action_just_pressed("ui_up"):
			$SoundCursor.play(0)
			cursor -= 1
			# Godot's modulo operator doesn't wrap negative numbers for some reason
			# So we have to use fposmod, which does, and cast it back to int.
			cursor = int(fposmod(cursor, len(boxes))) 
		if Input.is_action_just_pressed("ui_down"):
			$SoundCursor.play(0)
			cursor += 1
			cursor = cursor % len(boxes)
	
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_select"):
			$SoundSelect.play(0)
			selected = true
			match(cursor):
				0: # START
					for key in controller.flag:
						controller.flag[key] = 0
					controller.player_health = 10
					controller.player_corruption = 0
					controller.player_gold = 20
					controller.player_potions = 5

					controller.corrupted_cells_add = []
					
					Player.dead = false
					Player.fully_corrupted = false
					
					audioplayer.init = true
					
					$TimerClearStuff.start()
					$TimerTransition.start()
					$TimerTransition2.start()
				
				1: # SETTINGS
					$TimerClearStuff.start()
					$TimerShowSettings.start()
					
				2: # CREDITS
					$TimerClearStuff.start()
					credits_t = 0
					credits_stage = -1
					$TimerShowCredits.start()
					
				3: # EXIT
					$TimerClearStuff.start()
					$TimerExit.start()
					$PartsTitle.set_emitting(false)
					
	if credits_cancel and roll_credits:
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_select") or Input.is_action_just_pressed("ui_cancel"):
			credits_t = 0
			credits_stage = 0
			roll_credits = false
			$TimerShowStuff.start()
	if go_to_settings:
		if Input.is_action_just_pressed("ui_cancel"):
			settings_state = 2

func _on_TimerFadeInLogo_timeout():
	logo_speed = 1.5
	logo_active = true

func _on_TimerFadeInOptions_timeout():
	options_active = true

func _on_TimerFadeInBoxes_timeout():
	boxes_alpha = 0
	boxes_active = true
	$Box2.scale = Vector2(3.9, 0.9)
	box3.scale = Vector2(3.7,0.9)
	selected = false

func _on_TimerClearStuff_timeout():
	logo_acc = 0
	logo_speed = 1.2
	options_acc = 0
	logo_active = false
	options_active = false

func _on_TimerTransition_timeout():
	$Transition.show()
	transition_active = true

func _on_TimerTransition2_timeout():
	TransitionNoise.active = true
	audioplayer.fade_noise = false
	audioplayer.fade_noise_sub = -0.3
	audioplayer.get_node("SoundNoiseTransition").set_volume_db(-5)
	audioplayer.get_node("SoundNoiseTransition").play(0)
	$TimerStartGame.start()

func _on_TimerStartGame_timeout():
	controller.scene_change("res://Scenes/Buildings/FioreHouse.tscn", false)
	Player.set_position(Vector2(108,68))
	Player.show()
	Player.face = Vector2(-1,0)
	Player.get_node("Sprite").play("left")
	TransitionNoise.get_node("TimerActive").start()

func _on_TimerExit_timeout():
	get_tree().quit()

func _on_TimerShowCredits_timeout():
	credits_t = 0
	credits_stage = -1
	roll_credits = true
	$TimerAllowExitCredits.start()

func _on_TimerAllowExitCredits_timeout():
	credits_cancel = true

func _on_TimerShowStuff_timeout():
	$TimerFadeInLogo.start()
	$TimerFadeInOptions.start()
	$TimerFadeInBoxes.start()


func _on_TimerShowSettings_timeout():
	go_to_settings = true
	settings_state = 0
	$"OptionsGroup/Music Slider".visible = true
	$"OptionsGroup/Effects Slider".visible = true

func _on_Music_Slider_value_changed(value):
	controller.audio_music_percent = value
	controller.update_bus_volume(1, controller.audio_music_percent)
	
func _on_Effects_Slider_value_changed(value):
	controller.audio_effects_percent = value
	controller.update_bus_volume(2, controller.audio_effects_percent)

func _on_Music_Slider_gui_input(ev):
	if ev is InputEventMouseButton:
		if ev.pressed == false:
			$MusicSample.play()


func _on_Effects_Slider_gui_input(ev):
	if ev is InputEventMouseButton:
		if ev.pressed == false:
			$SoundCursor.play()

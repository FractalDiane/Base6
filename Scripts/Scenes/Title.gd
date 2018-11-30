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

var credits_t = 0
var credits_stage = -1
var roll_credits = false
var credits_actives = [false]
var credits_accs = [1,1,1,1,1,1,1,1,1,1,1,1,1]
var credits_alphas = [0,0,0,0,0,0,0,0,0,0,0,0,0]
var credits_cancel = false

var transition_acc = 1
var transition_active = false

onready var logo = $Logo
onready var wipe = $Transition
onready var credits = $CreditsGroup
onready var box2 = $Box2

func _ready():
	Player.state = Player.NO_INPUT
	$Transition.hide()
	
	logo.set_modulate(Color(1,1,1,0))
	logo.position.y -= 40
	options.append(get_node("START"))
	options.append(get_node("CREDITS"))
	options.append(get_node("EXIT"))
	
	for op in options:
		op.set_modulate(Color(1,1,1,0))
		op.margin_top += 40
		
	boxes[0] = get_node("Box1")
	boxes[1] = get_node("Box2")
	boxes[2] = get_node("Box3")
	
	for box in boxes:
		boxes[box].set_modulate(Color(1,1,1,0))
		
	credits_actives.resize(13)
	for val in credits_actives:
		val = false
		
	for node in credits.get_children():
		node.margin_left -= 100
	
func _physics_process(delta):
	if logo_active:
		logo_acc = clamp(logo_acc - 0.0185,0,1)
		logo_alpha = clamp(logo_alpha + 0.025,0,1)
		
		logo.position.y = min(logo.position.y + (logo_speed * logo_acc), 58)
		logo.set_modulate(Color(1,1,1,logo_alpha))
	else:
		logo_acc = clamp(logo_acc + 0.0185,0,1)
		logo_alpha = clamp(logo_alpha - 0.025,0,1)
		
		logo.position.y = max(logo.position.y - (logo_speed * logo_acc), 18)
		logo.set_modulate(Color(1,1,1,logo_alpha))
		
	if options_active:
		options_acc = clamp(options_acc - 0.015,0,1)
		options_alpha = clamp(options_alpha + 0.025,0,1)
		
		for op in options:
			op.margin_top = max(op.margin_top - (options_speed * options_acc),82 + 11 * options.find(op))
			op.set_modulate(Color(1,1,1,options_alpha))
	else:
		options_acc = clamp(options_acc + 0.015,0,1)
		options_alpha = clamp(options_alpha - 0.025,0,1)
		
		for op in options:
			op.margin_top = min(op.margin_top + (options_speed * options_acc),122 + 11 * options.find(op))
			op.set_modulate(Color(1,1,1,options_alpha))
			
	if boxes_active:
		if not box2.is_visible():
			box2.show()
		boxes_alpha = clamp(boxes_alpha + 0.025,0,1)
		for box in boxes:
			if box == cursor:
				boxes[box].set_modulate(Color(1,1,1,boxes_alpha))
			else:
				boxes[box].set_modulate(Color(1,1,1,0))
			
		if selected:
			boxes[cursor].scale.x += 0.1
			boxes[cursor].scale.y -= 0.1
			if boxes[cursor].scale.y <= 0:
				boxes[cursor].hide()
				boxes_active = false
				
	if roll_credits:
		credits_t += 1
		if credits_t % 6 == 0:
			credits_stage += 1
		for node in credits.get_children():
			var i = credits.get_children().find(node)
			if credits_stage >= i:
				credits_actives[i] = true
				
		for node in credits.get_children():
			var i = credits.get_children().find(node)
			if credits_actives[i]:
				credits_alphas[i] = clamp(credits_alphas[i] + 0.03,0,1)
				credits_accs[i] = clamp(credits_accs[i] - 0.02,0,1)
				
				credits.get_child(i).margin_left += 4 * credits_accs[i]
				credits.get_child(i).set_modulate(Color(1,1,1,credits_alphas[i]))
	else:
		credits_t += 1
		if credits_t % 6 == 0:
			credits_stage += 1
		for node in credits.get_children():
			var i = credits.get_children().find(node)
			if credits_stage >= i:
				credits_actives[i] = false

		for node in credits.get_children():
			var i = credits.get_children().find(node)
			if not credits_actives[i]:
				credits_alphas[i] = clamp(credits_alphas[i] - 0.03,0,1)
				credits_accs[i] = clamp(credits_accs[i] + 0.02,0,1)

				credits.get_child(i).margin_left = max(credits.get_child(i).margin_left - 4 * credits_accs[i],-95)
				credits.get_child(i).set_modulate(Color(1,1,1,credits_alphas[i]))
		
	input()
		
	if transition_active:
		transition_acc = clamp(transition_acc - 0.0115,0,1)
		wipe.scale.x += (0.375 * transition_acc)
		
func input():
	if not selected and boxes_active:
		if Input.is_action_just_pressed("ui_up"):
			$SoundCursor.play(0)
			cursor -= 1
			if cursor < 0:
				cursor = 2
		if Input.is_action_just_pressed("ui_down"):
			$SoundCursor.play(0)
			cursor += 1
			if cursor > 2:
				cursor = 0
	
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
					controller.player_potions = 3
					controller.player_item_1 = 0
					controller.corrupted_cells = ["14","23","24","33","34","44"]
					
					Player.dead = false
					Player.fully_corrupted = false
					
					audioplayer.init = true
					
					$TimerClearStuff.start()
					$TimerTransition.start()
					$TimerTransition2.start()
					
				1: # CREDITS
					$TimerClearStuff.start()
					credits_t = 0
					credits_stage = -1
					$TimerShowCredits.start()
					
				2: # EXIT
					$TimerClearStuff.start()
					$TimerExit.start()
					$PartsTitle.set_emitting(false)
					
	if credits_cancel and roll_credits:
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_select") or Input.is_action_just_pressed("ui_cancel"):
			credits_t = 0
			credits_stage = 0
			roll_credits = false
			$TimerShowStuff.start()

func _on_TimerFadeInLogo_timeout():
	logo_speed = 1.5
	logo_active = true

func _on_TimerFadeInOptions_timeout():
	options_active = true

func _on_TimerFadeInBoxes_timeout():
	boxes_alpha = 0
	boxes_active = true
	box2.scale = Vector2(3.7,0.9)
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

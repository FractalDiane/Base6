extends CanvasLayer

var box_x = 0
var box_y = 0
var box_width = 10
var box_height = 10
var ww = 5
var hh = 5

var stage = 0

var text = []
var text_page = 0
var length = 0
onready var page_length = len(text[0].replace(' ', ''))

var text_roll = false
var t = -1
var sound = -1

var target = null
var destroy_event = false
var restore_walk = false

var buffer = false

# Object node references
onready var dbox = $Box
onready var DText = $DText
onready var SoundType = $SoundType

func _ready():
	dbox.set_position(Vector2(box_x, box_y))
	DText.set_position(Vector2(box_x + 6, box_y + 6))
	DText.set_end(Vector2(box_x + box_width - 6, box_y + box_height - 6))
	#$Sound1.play(0)

func _physics_process(delta):
	if stage == 0: # Expand H
		ww = clamp(ww + (box_width / 20),5,box_width)
		if ww >= box_width:
			#$Sound2.play(0)
			stage = 1
	if stage == 1: # Expand V
		hh = clamp(hh + (box_height / 20),5,box_height)
		if hh >= box_height:
			$TimerStart.start()
			stage = 2
	if stage == 2 and text_roll: # Text rolling
		roll_text()
	if stage == 3: # Contract V
		hh = clamp(hh - (box_height / 18),5,box_height)
		if hh <= 5:
			#$Sound2.play(0)
			stage = 4
	if stage == 4: # Contract H
		ww = clamp(ww - (box_width / 18),5,box_width)
		if ww <= 5:
			#on_destroy()
			queue_free()
	
	dbox.set_size(Vector2(ww, hh))
	DText.set_text(text[text_page]) # Get the current page of text we're on
	DText.set_visible_characters(length) # Set the visible text to however long it has progressed
	
func roll_text():
	# Godot labels ignore spaces when counting visible characters
	# So we need to delete all the spaces when we calculate the length of a string.
	if length < page_length:
		t += 1
		sound += 1
		
		if sound % 6 == 0: # Type sound timer
			#SoundType.set_pitch_scale(rand_range(0.9,1.1))
			#SoundType.play(0)
			pass
		
		if t % 5 == 0: # Text progress timer
			length += 1
		
		if Input.is_action_just_pressed("ui_accept") and not buffer: # Show all text
			advance_text()
	else:
		if Input.is_action_just_pressed("ui_accept") and not buffer: # Go to next page of text
			advance_page()
	
func advance_text():
	length = page_length
	buffer = true
	$TimerBuffer.start()
	
func advance_page():
	length = 0
	if text_page + 1 < len(text):
		text_page += 1
		page_length = len(text[text_page].replace(' ', ''))
	else:
		#$Sound1.play(0)
		on_destroy()
		stage = 3
		
func on_destroy():
	if destroy_event:
		get_tree().get_root().get_node("Node2D").get_node("GLITCHLAYER").get_node("PartsGLITCH").set_emitting(true)
		get_tree().get_root().get_node("Node2D").get_node("GLITCHLAYER").get_node("PartsGLITCH").get_node("GLITCH").show()
		get_tree().get_root().get_node("Node2D").get_node("SoundStatic").play(0)
		get_tree().get_root().get_node("Node2D").get_node("TimerGlitch").start()
		
	if target.get_name() == "RegistryEntryTrigger":
		target.get_node("MusicConfrontation").stop()
		controller.scene_change("res://Scenes/GATE/Gate-FINALBOSS2.tscn", false)
		Player.hide()
		
	if target.get_name() == "Registry2":
		target.get_node("TimerStartBoss").start()
		audioplayer.get_node("MusicFinalBoss").play(0)
		audioplayer.current_music = audioplayer.get_node("MusicFinalBoss").stream
		
	if target.get_name() == "RegistryAfter1":
		controller.scene_change("res://Scenes/GATE/Gate-FINALBOSSAfter2.tscn", false)
		Player.set_position(Vector2(80, 100))
		Player.show()
		
	if target.get_name() == "RegistryAfter2":
		if controller.holding_theitem:
			controller.scene_change("res://Scenes/GATE/Gate-TrueEnd1.tscn")
		else:
			Player.state = Player.WALK
			
	if target.get_name() == "RegistryBadEnd":
		controller.scene_change("res://Scenes/GATE/Gate-BadEnd3.tscn", false)
		
	if target.get_name() == "RegistryBadEnd2":
		controller.scene_change("res://Scenes/CreditsBad.tscn", false)
		
	if target.is_in_group("TrueEnd1") or target.is_in_group("TrueEnd3"):
		get_tree().get_root().get_node("Node2D").lock = false
		
	if target.get_name() == "RegistryTrueEnd":
		controller.scene_change("res://Scenes/GATE/Gate-TrueEnd5.tscn", false)
		
	if target.get_name() == "RegistryTrueEnd2":
		controller.scene_change("res://Scenes/GATE/Gate-TrueEnd6.tscn", false)
		
	if target.get_name() == "RegistryTrueEnd3":
		controller.scene_change("res://Scenes/CreditsTrue.tscn", false)
		
#	length = 0
#	target.get_node("Sprite").set_animation("down")
#	if target.dialogue_key != "null" and target.auto_advance_set:
#		 controller.flag[target.dialogue_key] = clamp(controller.flag[target.dialogue_key] + 1,0,target.auto_advance_limit)
	if restore_walk:
		Player.state = Player.WALK
#
#	# CAW!!
#	if target.get_name() == "NPCFountainPlaque":
#		audioplayer.get_node("SoundCrow").play(0)
#		var fountainparts = get_tree().get_root().get_node("Node2D").get_node("Fountain").get_node("PartsCaw")
#		fountainparts.set_emitting(true)

func _on_TimerStart_timeout():
	text_roll = true

func _on_TimerBuffer_timeout():
	buffer = false

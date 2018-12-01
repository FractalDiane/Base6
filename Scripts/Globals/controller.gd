extends Node

# GLOBAL GAME CONTROLLER

var flag = {}

var main = null
var dlg = preload("res://Instances/System/Dialogue.tscn")
var dlg2 = preload("res://Instances/System/DialogueRegistry.tscn")
var corr_parts = preload("res://Instances/Particles/PartsPlayerCorrupt.tscn")

# Global variables
var player_health = 10
var player_corruption = 0
var player_gold = 20
var player_potions = 3

var current_scene = null
var corrupted_cells = ["14","23","24","33","34","44"]
# Cells to add after first dungeon: ["03","04","12","13","32","?1"]

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	main = get_parent().get_node("Node2D")
	audioplayer.update_music()

func _scene_start(reset_state):
	if not audioplayer.init:
		audioplayer.call_deferred("update_music")
	Screencap.fade = true
	Screencap.reset_state = reset_state
	Screencap.get_node("TimerRestart").start()
	#if not Player.is_visible():
		#Player.get_node("TimerShow").start()
	
func _scene_end(reset_state):
	if reset_state:
		Player._on_TimerDash_timeout()
	for node in get_parent().get_node("Node2D").get_children():
		if node.is_in_group("Transition"):
			if node.corr:
				node.corruption_parts.queue_free()
	
# ======================================================================== GLOBAL FUNCTIONS
func scene_change(scene, reset_state = true):
	_scene_end(reset_state)
	get_tree().change_scene(scene)
	_scene_start(reset_state)
	
func set_flag(key, value):
	flag[key] = value
	
func dialogue(text,target_object,box_x,box_y,box_width,box_height):
	Player.state = Player.DIALOGUE
	var dialogue_node = dlg.instance()
	dialogue_node.box_x = box_x
	dialogue_node.box_y = box_y
	dialogue_node.box_width = box_width
	dialogue_node.box_height = box_height
	dialogue_node.target = target_object
	dialogue_node.text = text
	get_tree().get_root().add_child(dialogue_node)
	
func dialogue_registry(text,target_object,box_x,box_y,box_width,box_height):
	#Player.state = Player.DIALOGUE
	var dialogue_node = dlg2.instance()
	dialogue_node.box_x = box_x
	dialogue_node.box_y = box_y
	dialogue_node.box_width = box_width
	dialogue_node.box_height = box_height
	dialogue_node.target = target_object
	dialogue_node.text = text
	get_tree().get_root().add_child(dialogue_node)
	
func player_damage(amount):
	if not Player.iframes:
		audioplayer.play_sound("SoundPlayerDamage")
		player_health -= amount
		Player.get_node("PartsHurt").set_emitting(true)

func player_corrupt(amount):
	audioplayer.play_sound("SoundPlayerCorrupt")
	player_corruption += amount
	Player.color = 0
	var parts = corr_parts.instance()
	parts.set_position(Player.get_position())
	parts.set_amount(player_corruption * 2)
	parts.set_emitting(true)
	get_parent().get_node("Node2D").add_child(parts)
	
# ======================================================================== TOOL FUNCTIONS
func wave(from, to, duration, offset, time_var, delta):
	var a = (to - from) * 0.5
	return from + a + sin((((time_var * delta) + duration * offset) / duration) * (PI/2)) * a
extends Node

# GLOBAL GAME CONTROLLER

var flag = {}

var main = null
var dlg = preload("res://Instances/System/Dialogue.tscn")
var corr_parts = preload("res://Instances/Particles/PartsPlayerCorrupt.tscn")

const NONE = 0
const BOW = 1

# Global variables
var player_health = 10
var player_corruption = 0
var player_gold = 20

var player_item_1 = BOW
var player_item_2 = NONE

var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	main = get_parent().get_node("Node2D")
	audioplayer.update_music()

func _scene_start():
	audioplayer.call_deferred("update_music")
	Screencap.fade = true
	Screencap.get_node("TimerRestart").start()
	
# ======================================================================== GLOBAL FUNCTIONS
func scene_change(scene):
	get_tree().change_scene(scene)
	_scene_start()
	
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

func player_corrupt(amount):
	audioplayer.play_sound("SoundPlayerCorrupt")
	player_corruption += 1
	Player.color = 0
	var parts = corr_parts.instance()
	parts.set_position(Player.get_position())
	parts.set_amount(player_corruption * 2)
	parts.set_emitting(true)
	get_parent().get_node("Node2D").add_child(parts)
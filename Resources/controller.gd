extends Node

# GLOBAL GAME CONTROLLER

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
extends Node

# GLOBAL GAME CONTROLLER

# Global variables
var player_health = 10
var player_corruption = 0
var player_gold = 20

var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
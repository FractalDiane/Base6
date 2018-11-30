extends Area2D

export(int) var gold_value = 5
export(bool) var large_sprite = false
export(String) var target_flag = null

var enable = true

onready var player = Player

func _ready():
	if target_flag != null and controller.flag[target_flag] == 1:
		queue_free()
		
	if large_sprite:
		$Sprite.play("large")
	else:
		$Sprite.play("small")

func _physics_process(delta):
	if enable:
		var coll = get_overlapping_bodies()
		if player in coll:
			audioplayer.get_node("SoundGetItem").play(0)
			get_tree().get_root().get_node("Node2D").get_node("UI").get_node("Gold").get_node("GoldSprite").play("move")
			controller.player_gold += gold_value
			controller.flag[target_flag] = 1
			queue_free()

func _on_TimerEnable_timeout():
	enable = true

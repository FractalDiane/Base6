extends Area2D

export(bool) var one_shot = true
export(float) var time = 0

signal on_pressed

var pressed = false

onready var player = Player

func _physics_process(delta):
	if not pressed:
		var coll = get_overlapping_bodies()
		for node in coll:
			if node == player or node.is_in_group("Pushables"):
				$SoundPressed.play(0)
				$Sprite.set_animation("down")
				emit_signal("on_pressed")
				pressed = true

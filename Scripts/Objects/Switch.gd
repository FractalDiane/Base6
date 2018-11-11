extends Area2D

export(bool) var one_shot = true
export(float) var time = 0
export(String) var target_flag = "null"
export(bool) var reemit_signal = false

signal on_pressed

var pressed = false

onready var player = Player

func _ready():
	if target_flag != "null" and controller.flag[target_flag] == 1:
		$Sprite.set_animation("down")
		if reemit_signal:
			$TimerReemitSignal.start()
		pressed = true

func _physics_process(delta):
	if not pressed:
		var coll = get_overlapping_bodies()
		for node in coll:
			if node == player or node.is_in_group("Pushables"):
				$SoundPressed.play(0)
				$Sprite.set_animation("down")
				emit_signal("on_pressed")
				if target_flag != "null":
					controller.flag[target_flag] = 1
				pressed = true

func _on_TimerReemitSignal_timeout():
	emit_signal("on_pressed")

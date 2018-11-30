extends StaticBody2D

export(int) var cost = 20
export(int, "Potion", "Sword") var item = 0
	
var show_interact = false

onready var interact = $Interact

func _ready():
	interact.set_text(str(cost))

func _physics_process(delta):
	if show_interact and Player.state == Player.WALK:
			interact.show()
			interaction()
	else:
		interact.hide()
		
func interaction():
	if Input.is_action_just_pressed("ui_accept"):
		
		if controller.player_gold >= cost:
			match(item):
				0: # Potion
					controller.player_potions = clamp(controller.player_potions + 1, 0, 99)
			$SoundBuy.play(0)
			get_tree().get_root().get_node("Node2D").get_node("UI").get_node("Gold").get_node("GoldSprite").play("move")
			controller.player_gold = max(controller.player_gold - cost, 0)

func _on_TimerHideInteract_timeout():
	show_interact = false

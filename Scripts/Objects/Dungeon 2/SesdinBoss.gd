extends KinematicBody2D

var active = false

onready var points = get_tree().get_root().get_node("Node2D").get_node("TeleportPoints")

func _ready():
	$Sprite.hide()
	$CollisionPolygon2D.set_disabled(true)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_TimerTP_timeout():
	$SoundTeleport.play(0)
	$PartsTeleport.set_emitting(true)
	
	var rng = round(rand_range(0,4))
	var target = points.get_child(rng)
	set_position(target.get_position())
	$Sprite.play(target.sesdin_direction)
	
	$Sprite.show()
	$CollisionPolygon2D.set_disabled(false)
	
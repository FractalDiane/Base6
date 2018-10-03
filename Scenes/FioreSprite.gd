extends AnimatedSprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _process(delta):
	set_ofs()
	
var offsets = [Vector2(-7,13), Vector2(4,13), Vector2(-7,13), Vector2(4,13)]

func set_ofs():
	offset = offsets[frame]

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

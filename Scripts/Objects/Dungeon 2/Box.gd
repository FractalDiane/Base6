extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var player = Player

func _physics_process(delta):
	set_z_index(get_position().y)
	
extends StaticBody2D

var parts_scene = preload("res://Instances/Particles/PartsWorldborder.tscn")

func _ready():
	# Create particles
	var parts = parts_scene.instance()
	
	# Set up particles' scale/
	parts.set_position(Vector2(get_position().x,get_position().y))
	parts.get_process_material().set_emission_box_extents(Vector3(get_scale().x * 32,get_scale().y * 32,0))
		
	get_tree().get_root().call_deferred("add_child",parts)
	
	print(parts.get_position())
	print(str(parts.get_process_material().get_emission_box_extents()) + "\n")
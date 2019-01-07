extends Area2D

export(String, FILE, "*.tscn") var target_scene
export(int) var target_x
export(int) var target_y
export(String, "up", "down", "left", "right") var direction
export(bool) var not_cell = false
export(bool) var checkpoint = false

var respawn = false

var corr = false
var corruption_parts = null

func _ready():
	#var current_cell = call_deferred(get_tree().edited_scene_root.filename)
	#var current_cell_str = current_cell.replace(current_cell.get_extension(),"").substr(0,2)
	#if current_cell_str in controller.corrupted_cells:
	var target_cell_str = target_scene.get_file().replace(target_scene.get_extension(),"").substr(0,2)
	if target_cell_str in controller.corrupted_cells or target_cell_str in controller.corrupted_cells_add:
		if get_scale().x > get_scale().y: # Horizontal
			corruption_parts = load("res://Instances/Particles/PartsCorruptionBorder.tscn").instance()
		elif get_scale().y > get_scale().x: # Vertical
			corruption_parts = load("res://Instances/Particles/PartsCorruptionBorderV.tscn").instance()
		corruption_parts.set_position(get_position())
		get_tree().get_root().add_child(corruption_parts)
		corr = true
			
func _physics_process(delta):
	var colliding = get_overlapping_bodies()
	
	for obj in colliding:
		if obj.get_name() == "Player" and not Player.warp and Player.state != Player.NO_INPUT:
			var player_x = obj.get_position().x
			var player_y = obj.get_position().y
			var target_x_f
			var target_y_f
			
			if not not_cell:
				if direction == "up" or direction == "down":
					target_x_f = player_x
					target_y_f = target_y
				elif direction == "left" or direction == "right":
					target_x_f = target_x
					target_y_f = player_y
			else:
				target_x_f = target_x
				target_y_f = target_y
				
			var target_dir
			if direction == "up":
				target_dir = Vector2(0,-1)
			elif direction == "down":
				target_dir = Vector2(0,1)
			elif direction == "left":
				target_dir = Vector2(-1,0)
			elif direction == "right":
				target_dir = Vector2(1,0)
			
			# Set player properties
			Player.warp = true
			Player.state = Player.NO_INPUT
			Player.motion = Vector2(0,0)
			Player.sound = -1
			
			# Get screencap for transition
			var scrncap = get_viewport().get_texture().get_data()
			scrncap.flip_y()
			var screencap_tex = ImageTexture.new()
			screencap_tex.create_from_image(scrncap)
			Screencap.get_node("Sprite").texture = screencap_tex
			
			controller.scene_change(target_scene)
			Player.set_position(Vector2(target_x_f,target_y_f))
			Player.face = target_dir
			Player.get_node("Sprite").play(direction)
			Player.get_node("TimerWarp").start()
			if respawn:
				$TimerRespawn.start()
				respawn = false
			
			if checkpoint:
				controller.x_checkpoint = Player.get_position().x
				controller.y_checkpoint = Player.get_position().y
				controller.hp_checkpoint = controller.player_health
				controller.corr_checkpoint = controller.player_corruption
				controller.gold_checkpoint = controller.player_gold
				controller.potions_checkpoint = controller.player_potions
				controller.scene_checkpoint = target_scene
				controller.flag_checkpoint = controller.flag.duplicate()
				controller.corrupted_cells_add_checkpoint = controller.corrupted_cells_add.duplicate()
				

func _on_TimerRespawn_timeout():
	Player.respawn = false
	Player.falling = false
	Player.scale = Vector2(1,1)
	#get_tree().get_root().get_node("Node2D").get_node("PitController").respawn_direction = direction
	queue_free()

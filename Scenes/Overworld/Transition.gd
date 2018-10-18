extends Area2D

export(String, FILE, "*.tscn") var target_scene
export(int) var target_x
export(int) var target_y
export(String, "up", "down", "left", "right") var direction

func _physics_process(delta):
	var colliding = get_overlapping_bodies()
	
	for obj in colliding:
		if obj.get_name() == "Player" and not Player.warp:
			var player_x = obj.get_position().x
			var player_y = obj.get_position().y
			var target_x_f
			var target_y_f
			
			if direction == "up" or direction == "down":
				target_x_f = player_x
				target_y_f = target_y
			elif direction == "left" or direction == "right":
				target_x_f = target_x
				target_y_f = player_y
				
			# Stop player walking animation
			if Player.get_node("Sprite").get_animation() in ["walkup"]:
				Player.get_node("Sprite").play("up")
			elif Player.get_node("Sprite").get_animation() in ["walkdown"]:
				Player.get_node("Sprite").play("down")
			elif Player.get_node("Sprite").get_animation() in ["walkleft, swingleft"]:
				Player.get_node("Sprite").play("left")
			elif Player.get_node("Sprite").get_animation() in ["walkright", "swingright"]:
				Player.get_node("Sprite").play("right")
			
			Player.warp = true
			Player.state = Player.NO_INPUT
			Player.motion = Vector2(0,0)
			
			# Get screencap for transition
			var scrncap = get_viewport().get_texture().get_data()
			scrncap.flip_y()
			var screencap_tex = ImageTexture.new()
			screencap_tex.create_from_image(scrncap)
			Screencap.texture = screencap_tex
			Screencap.fade = true
			Screencap.get_node("TimerStopFade").start()
			
			controller.scene_change(target_scene)
			Player.set_position(Vector2(target_x_f,target_y_f))
			#Player.get_node("Sprite").play(direction)
			Player.get_node("TimerWarp").start()
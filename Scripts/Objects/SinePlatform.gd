extends Area2D

export(int) var move_range = 32
export(float) var time = 2
export(bool) var vertical = false

var colliding = false
var colliding_body

var t = 0
var add = 0
onready var startpos = get_position()
onready var player = Player
onready var player_sprite = Player.get_node("Sprite")
onready var player_sprite_initial_position = player_sprite.position
var offset = Vector2(0, 0)
onready var area = $Area2D
onready var sprite = $Sprite

func _physics_process(delta):
	#set_z_index(get_position().y)
	t += 1
	add = controller.wave(0, move_range, time, 0, t, delta)
	
	var add_vector
	if vertical:
		add_vector = Vector2(0, add)
	else:
		add_vector = Vector2(add, 0)
	var velocity = ((startpos + add_vector) - position) / delta
	set_position(startpos + add_vector)
	sprite.set_global_position(Vector2(round(global_position.x), round(global_position.y)))
	if colliding:
		player.move_and_slide(velocity)
		if abs((player.global_position - global_position).x - offset.x) > 1 or abs((player.global_position - global_position).y - offset.y) > 1:
			offset = Vector2(round(player.global_position.x - global_position.x), round(player.global_position.y - global_position.y))
		player_sprite.global_position = Vector2(round(global_position.x + offset.x + player_sprite_initial_position.x), round(global_position.y + offset.y + player_sprite_initial_position.y))

func _on_Platform_body_entered(body):
	colliding = true
	colliding_body = body

func _on_Platform_body_exited(body):
	body.set("platform_motion", Vector2(0,0))
	colliding = false
	colliding_body = null
	player_sprite.position = player_sprite_initial_position

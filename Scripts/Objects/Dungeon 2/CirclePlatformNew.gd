extends Area2D

export(int) var move_range = 32
export(float) var time = 2
export(bool) var vertical = false

var angle = 90
var target_angle = 90
var radius = 24

var colliding = false
var colliding_body

#var t = 0
var add = 0
onready var startpos = get_position()
onready var player = Player
onready var player_sprite = Player.get_node("Sprite")
onready var player_sprite_initial_position = player_sprite.position
var offset = Vector2(0, 0)
onready var area = $Area2D
onready var sprite = $Sprite

func _physics_process(delta):
	angle = clamp(angle - controller.convert_to_seconds(2, delta), target_angle, target_angle + 90)
	var angle_rad = deg2rad(angle)
	var pos_x = (radius * 2) * cos(angle_rad) + 36
	var pos_y = radius * sin(angle_rad)
	
	var add_vector = Vector2(pos_x, pos_y)
	var velocity = ((startpos + add_vector) - position) / delta
	set_position(startpos + add_vector)
	sprite.set_global_position(Vector2(round(global_position.x), round(global_position.y)))
	if colliding:
		player.move_and_slide(velocity)
		if abs((player.global_position - global_position).x - offset.x) > 1 or abs((player.global_position - global_position).y - offset.y) > 1:
			offset = Vector2(round(player.global_position.x - global_position.x), round(player.global_position.y - global_position.y))
		player_sprite.global_position = Vector2(round(global_position.x + offset.x + player_sprite_initial_position.x), round(global_position.y + offset.y + player_sprite_initial_position.y))

func shift():
	target_angle -= 90

func _on_Platform_body_entered(body):
	colliding = true
	colliding_body = body

func _on_Platform_body_exited(body):
	body.set("platform_motion", Vector2(0,0))
	colliding = false
	colliding_body = null
	player_sprite.position = player_sprite_initial_position

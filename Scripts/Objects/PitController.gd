extends Area2D

export(bool) var has_platform = false

var respawn_pos = Vector2(0,0)
var respawn_direction = Vector2(0,0)

var monitor = false
var respawning = false

onready var player = Player
var platform

func _ready():
	respawn_pos = player.get_position()
	respawn_direction = player.face
	if has_platform:
		platform = $Platform

func _physics_process(delta):
	if monitor and not respawning and not player.falling and not player.jumping and not player.respawn:
		var coll = get_overlapping_bodies()
		if player_should_fall(coll):
			fall()

func fall():
	player.get_node("SoundFall").play(0)
	player.falling = true
	respawning = true
	player.state = player.NO_INPUT
	$TimerRespawn.start()
	
func player_should_fall(coll):
	if has_platform:
		return not player in coll and not platform.colliding
	else:
		return not player in coll
	
func _on_TimerStartMonitor_timeout():
	monitor = true

func _on_TimerRespawn_timeout():
	controller.player_health -= 1
	player.respawn = true
	player.falling = false
	player.scale = Vector2(1,1)
	player.set_position(respawn_pos)
	player.face = respawn_direction
	player.state = player.WALK
	player.falling = false
	player.respawn = false
	player.show()
	$TimerRespawn2.start()
	
func _on_TimerRespawn2_timeout():
	respawning = false

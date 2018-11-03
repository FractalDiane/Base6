extends KinematicBody2D

export(int) var health = 9

var iframes = false
var alpha = 1
var fade = false

var flash = 0

var dead = false

onready var spr = $Sprite

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	set_z_index(get_position().y)

	flash = clamp(flash - 0.0167,0,1)
	spr.get_material().set_shader_param("flash", flash)

	if fade:
		alpha = clamp(alpha - 0.05,0,1)
		spr.set_modulate(Color(0, 0, 0, alpha))

func deal_damage():
	flash = 1
	health -= 3
	if health <= 0:
		dead = true
		death()
	else:
		iframes = true
		$TimerIFrames.start()

func death():
	$SoundDeath.play(0)
	$SoundDeath2.play(0)
	fade = true
	$CollisionShape2D.set_disabled(true)
	$PartsGhast.set_emitting(false)
	$PartsDeathBurst.set_emitting(true)
	$PartsDeathGlitch.set_emitting(true)
	$TimerDeath1.start()

func _on_TimerIFrames_timeout():
	iframes = false

func _on_TimerDeath1_timeout():
	$PartsDeathGlitch.set_emitting(false)
	$TimerDeath2.start()

func _on_TimerDeath2_timeout():
	queue_free()

extends 'res://scripts/entity.gd'

const DAMAGE = 1
const SPEED = 30
const TYPE = 'ENEMY'

var movetimer = 0

func _ready():
	add_to_group('ENEMY')
	movedir = dir.rand()

func _process(delta):
	if health <= 0:
		destroy()
		
	if movetimer < 0.5:
		movetimer += delta
	else:
		movedir = dir.rand()
		movetimer = 0

func _physics_process(delta):
	movement_loop()
	damage_loop(delta)

func destroy():
	queue_free()
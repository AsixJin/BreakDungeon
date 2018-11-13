extends "res://scripts/entity.gd"

const DAMAGE = 1
const TYPE = 'ENEMY'

var movetimer = 2.5

func _ready():
	add_to_group('ENEMY')
	move()
	pass

func _process(delta):
	if health <= 0:
		destroy()
		
	movetimer -= delta
	modulate = Color(1,1,1,movetimer)
	if movetimer > 1:
		damage_loop(delta)
	if movetimer <= 0:
		move()
		movetimer = 2.5
	pass

func move():
	var x = rand_range(180, 285)
	var y = rand_range(160, 255)
	position = Vector2(x,y)

func destroy():
	queue_free()
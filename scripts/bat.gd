extends 'res://scripts/monster.gd'

const DAMAGE = 1
const SPEED = 30
const TYPE = 'ENEMY'

func _ready():
	# Set the bat's movement timer to zero (0)
	# so it will begin movement when instanced
	movetimer = 0
	# Give it a random direction
	movedir = dir.rand()

func _process(delta):
	# Destory the bat if its health is zero (0) or below
	if health <= 0:
		destroy()
	
	if movetimer < 0.5:
		# Run the timer until it reaches half a second (0.5)
		movetimer += delta
	else:
		# Once the movement timer has reached half a second (0.5)
		# Change the bat's movement direction and reset the timer
		movedir = dir.rand()
		movetimer = 0

func _physics_process(delta):
	movement_loop()
	damage_loop(delta)
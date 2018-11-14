extends "res://scripts/monster.gd"

const DAMAGE = 1
const TYPE = 'ENEMY'

func _ready():
	# The Ghost moves every two and a half (2.5) seconds
	movetimer = 2.5
	# Move it to a starting position
	move()

func _process(delta):
	# If the ghost health reaches zero (0)
	# destroy it
	if health <= 0:
		destroy()
	
	# Run the movement timer
	movetimer -= delta
	# Modulate the ghost's sprite color
	# This basically makes the ghost disappear
	# one second before it moves
	modulate = Color(1,1,1,movetimer)
	
	if movetimer > 1:
		# As long as the ghost isn't disappearing
		# It can be damaged
		damage_loop(delta)
	if movetimer <= 0:
		# Otherwise if the movement timer is zero (0) or under
		# Move the ghost and reset the timer
		move()
		movetimer = 2.5

# Ghost movement function
func move():
	# Randomly select a position within the arena bounds
	var x = rand_range(180, 285)
	var y = rand_range(160, 255)
	# And move the ghost there
	position = Vector2(x,y)

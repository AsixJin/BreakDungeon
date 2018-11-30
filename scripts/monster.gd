extends "res://scripts/entity.gd"

# Constants for monsters
const DAMAGE = 1
const TYPE = 'ENEMY'

# The monster's movement timer
var movetimer = 2.5

func _ready():
    # Every monster needs to add itself to the enemy group
	add_to_group('ENEMY')

func destroy():
	stats.monstersDestroyed += 1
	.destroy()
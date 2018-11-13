extends KinematicBody2D

onready var blockLineScn = preload("res://objects/block_line.tscn")
var descendSpeed = 1.5
var isDescending = true

var lastLine = null

func _ready():
	addFirstLine()

func _process(delta):
	if lastLine != null and lastLine.global_position.y >= -8:
		addLine()

func _physics_process(delta):
	if isDescending and lastLine != null:
		move_and_slide(Vector2(0, descendSpeed))

# Adds the first line to the container
func addFirstLine():
	var line = blockLineScn.instance()
	line.position = Vector2(0, -16)
	add_child(line)
	lastLine = line

# Adds a block line to the container
func addLine():
	var line = blockLineScn.instance()
	line.position = Vector2(0, lastLine.position.y-16)
	add_child(line)
	lastLine = line

# Increase the speed at which the blocks fall.
# The speed up is defaulted to 1 increment, but
# can take any int
func speedUp(spdIncrease=1):
	descendSpeed += spdIncrease
	print(str('Descending Speed is now ', descendSpeed))

# Decrease the speed at which the blocks fall.
# The speed down is defaulted to 1 increment, but
# can take any int
func speedDown(spdDecrease=1):
	descendSpeed -= spdDecrease
	print(str('Descending Speed is now ', descendSpeed))
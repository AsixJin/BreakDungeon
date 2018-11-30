extends Node2D

# Is this game running on a mobile device
var onMobile = false

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func disableMobileControls():
	hide()
	set_process(false)

func enableMobileControls():
	show()
	set_process(true)
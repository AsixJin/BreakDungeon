extends Node

var isPaused = false

func _process(delta):
	if Input.is_action_just_pressed('ui_pause'):
		isPaused = !isPaused
		get_tree().paused = isPaused
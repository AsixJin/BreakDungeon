extends Node

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _on_debug_pressed():
	switchLevel("res://levels/room.tscn")

func _on_marathon_pressed():
	switchLevel("res://levels/mara_room.tscn")

func _on_options_pressed():
	switchLevel("res://levels/options.tscn")

func switchLevel(level):
	get_tree().change_scene(level)
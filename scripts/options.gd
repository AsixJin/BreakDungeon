extends Node

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _on_title_pressed():
	switchLevel("res://levels/title.tscn")

func switchLevel(level):
	get_tree().change_scene(level)
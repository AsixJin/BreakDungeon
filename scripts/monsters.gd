extends Node

var monsters = {
	'bat': preload("res://entities/bat.tscn"),
	'ghost': preload("res://entities/ghost.tscn"),
}

func getMonster(name):
	return monsters[name]

func getRandomMonster():
	randomize()
	var choice = randi()%monsters.size()
	return monsters.values()[choice]
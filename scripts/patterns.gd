extends Node

var patterns = {
	# Alpha1 Patterns
	'line': preload('res://objects/block patterns/line_pattern.tscn'),
	'line2': preload('res://objects/block patterns/line2_pattern.tscn'),
	'person': preload('res://objects/block patterns/person_pattern.tscn'),
	'simple': preload("res://objects/block patterns/simple_pattern.tscn"),
	'lettera': preload('res://objects/block patterns/lettera_pattern.tscn'),
	# Alpha2 Patterns
	'letterb': preload('res://objects/block patterns/letterb_pattern.tscn'),
	'happyface': preload('res://objects/block patterns/happyface_pattern.tscn'),
	'question': preload('res://objects/block patterns/question_pattern.tscn'),
	'checkered': preload('res://objects/block patterns/checkered_pattern.tscn'),
	'pyramid': preload('res://objects/block patterns/pyramid_pattern.tscn')
}

func getPattern(name):
	return patterns[name]

func getRandomPattern():
	randomize()
	var choice = randi()%patterns.size()
	return patterns.values()[choice]
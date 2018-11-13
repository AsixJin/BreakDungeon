extends Node2D

export var defaultMonsterBlocks = 3

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func setSignals(room):
	for block in get_tree().get_nodes_in_group('BLOCKS'):
		block.connect('monstblockDestroyed', room, 'switchToFight')

func setMonsterBlocks(num=defaultMonsterBlocks):
	var blocks = get_tree().get_nodes_in_group('BLOCKS')
	var monsterBlocksAdded = 0
	while(monsterBlocksAdded != num):
		randomize()
		var choice = randi()%blocks.size()
		var block = blocks[choice]
		if block.isMonsterBlock:
			break
		else:
			block.isMonsterBlock = true
			monsterBlocksAdded+=1
			# Figure a better way to do this
			if block.maxDurability == 1:
				block.maxDurability = 2
				block.durability = 2
		pass
	pass

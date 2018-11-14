extends Node2D

# Arena Bounds
# Top Left: 180, 160
# Bottom Right: 285, 255

# Make an object singleton
# Maybe an entity singleton that can be built into the monster one
var ballScn = preload("res://entities/ball.tscn")
var arenaWallScn = preload("res://levels/arenaTiles.tscn")

var isBreakMode = true
var ball = null
var arenaWall = null

var spawnPoints = [Vector2(180, 160), Vector2(230,181), Vector2(285,160)]

func _ready():
	# connect player died signal
	# Make sure the player is in break mode
	$player.switchToBreak(false)
	## Generate a pattern
	initBlocks(blockpatt.getRandomPattern())
	pass

func _process(delta):
	# Code for the health UI
	# This needs to be in its own scene
	if $player.health > 6:
		$healthUI.frame = 6
	elif $player.health < 0:
		$healthUI.frame = 0
	else:
		$healthUI.frame = $player.health
	
	# If we are in fight mode with no monsters, switch to break mode
	if get_tree().get_nodes_in_group('ENEMY').size() == 0 and not isBreakMode:
		switchToBreak()
	# If there are no blocks in the room, generate a new pattern
	if get_tree().get_nodes_in_group('BLOCKS').size() == 0:
		initBlocks(blockpatt.getRandomPattern())

# Tell the player to create a new ball
func checkForBall():
	if isBreakMode:
		$player.createBall()
	pass

# Destroy the ball
func destroyBall():
	# Destroy ball
	if ball != null:
		ball.destroy(false)
		ball = null
	pass

# Generate a given block pattern
func initBlocks(patternScn):
	var newPattern = patternScn.instance()
	newPattern.position = Vector2(176,0)
	add_child(newPattern)
	newPattern.setSignals(self)
	newPattern.setMonsterBlocks()
	destroyBall()
	if isBreakMode:
		$player.createBall()

# Switch to break anytime all monsters are destroyed
func switchToBreak():
	# Make sure we aren't already in break mode
	if not isBreakMode:
		isBreakMode = true
		# Remove the arena walls
		if arenaWall != null:
			arenaWall.queue_free()
		# Switch the player to break mode
		$player.switchToBreak()
	else:
		# if we are in break mode, print to console
		# something might be wrong
		print('Warning: Tried to switch to break mode while in break moode')

# Switch to fight anytime a monster block is destroyed
func switchToFight():
	# Make sure we aren't already in fight mode
	if isBreakMode:
		isBreakMode = false
		# Destroy ball
		destroyBall()
		# Add the arena walls
		arenaWall = arenaWallScn.instance()
		arenaWall.position = Vector2()
		$mainTiles.add_child(arenaWall)
		# Switch the player to fight state
		$player.switchToFight()
		# Spawn monsters
		spawnMonsters()
	else:
		# if we are in fight mode, print to console
		# something might be wrong
		print('Warning: Tried to switch to fight mode while in fight moode')

# Spawn monsters into the areana portion of the room for fight mode
# If an amount of monsters is not given it will default to three (3)
func spawnMonsters(num=3):
	var monstersSpawned = 0
	# Spawns a monster in each spawn point (up to 3)
	# Should do this randomly without repeats for six (6) points
	while(monstersSpawned != num):
		# we pull a random monster from the database (should be able to have an option for monsters)
		var monster = monsterdb.getRandomMonster().instance()
		monster.position = spawnPoints[monstersSpawned]
		add_child(monster)
		monstersSpawned += 1

# When player runs out of hearts
func gameOver():
	# Show Game Over dialog
	# Allow button press to restart
	pass
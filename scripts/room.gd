extends Node2D

# Arena Bounds
# Top Left: 180, 160
# Bottom Right: 285, 255

# Make an object singleton
# Maybe an entity singleton that can be built into the monster one
var ballScn = preload("res://entities/ball.tscn")
var arenaWallScn = preload("res://levels/arenaTiles.tscn")

var isBreak = true
var ball = null
var arenaWall = null

var spawnPoints = [Vector2(180, 160), Vector2(230,181), Vector2(285,160)]

func _ready():
	# connect player died signal
	# Make sure the player is in break mode
	$player.switchToBreak(false)
	## Get some blocks in
	initBlocks(blockpatt.getRandomPattern())
	pass

func _process(delta):
	if $player.health > 6:
		$healthUI.frame = 6
	elif $player.health < 0:
		$healthUI.frame = 0
	else:
		$healthUI.frame = $player.health
		
	if get_tree().get_nodes_in_group('ENEMY').size() == 0 and not isBreak:
		switchToBreak()
	if get_tree().get_nodes_in_group('BLOCKS').size() == 0:
		initBlocks(blockpatt.getRandomPattern())

func checkForBall():
	if isBreak:
		$player.createBall()
	pass

func destroyBall():
	# Destroy ball
	if ball != null:
		ball.destroy(false)
		ball = null
	pass

func initBlocks(patternScn):
	var newPattern = patternScn.instance()
	newPattern.position = Vector2(176,0)
	add_child(newPattern)
	newPattern.setSignals(self)
	newPattern.setMonsterBlocks()
	destroyBall()
	if isBreak:
		$player.createBall()

# Switch to break anytime all monsters are destroyed
func switchToBreak():
	if not isBreak:
		isBreak = true
		# Remove the arena walls
		if arenaWall != null:
			arenaWall.queue_free()
		# Switch the player to break mode
		$player.switchToBreak()

# Switch to fight anytime a monster block is destroyed
func switchToFight():
	if isBreak:
		isBreak = false
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

func spawnMonsters(num=3):
	var monstersSpawned = 0
	while(monstersSpawned != num):
		var monster = monsterdb.getRandomMonster().instance()
		monster.position = spawnPoints[monstersSpawned]
		add_child(monster)
		monstersSpawned += 1

# When player runs out of hearts
func gameOver():
	# Show Game Over dialog
	# Allow button press to restart
	pass
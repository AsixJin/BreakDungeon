extends Sprite

const GROUP = 'BLOCKS'
const TYPE = 'BLOCK'

signal monstblockDestroyed

export var isMonsterBlock = false

export var setRandDurability = true
export var maxDurability = 1
var durability = 1

func _ready():
	add_to_group(GROUP)
	if setRandDurability:
		randomize()
		maxDurability = randi()%3+1
		if isMonsterBlock and maxDurability == 1:
			maxDurability = 2
		durability = maxDurability

func _process(delta):
	if durability <= 0:
		destroyBlock()
	
	frame = getDuraFrame()

func getDuraFrame():
	if durability >= maxDurability:
		return 0
	elif maxDurability == 3 and durability == 2:
		return 1
	else:
		if isMonsterBlock:
			return 3
		else:
			return 2

func revealMonsterBlock():
	# Play a sound or something
	print('Monster Block Revealed')
	pass

func destroyBlock():
	if isMonsterBlock:
		# Send a signal
		emit_signal('monstblockDestroyed')
	queue_free()

func _on_hitbox_body_entered(body):
	if body.get('TYPE') == 'BALL':
		durability -= 1
		if durability == 1 and isMonsterBlock:
			revealMonsterBlock()

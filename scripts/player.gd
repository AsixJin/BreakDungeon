extends 'res://scripts/entity.gd'

# Make an object singleton
# Maybe an entity singleton that can be built into the monster one
const paddleScn = preload('res://entities/paddle.tscn')
const ballScn = preload('res://entities/ball.tscn')

# The player's constantss
const PADDLESPEED = 70
const SPEED = 50
const TYPE = 'PLAYER'

# Signals
# Sends a signal when the ball needs to be launched
signal launchBall
# Sends a signal when the player has died
signal playerHasDied

# Variables
var inDebug = false

var paddle = null
var state = states.BREAK
var usingItem = false

func _ready():
	# If we are in break mode then create the paddle
	if state == states.BREAK:
		createPaddle()

func _process(delta):
	# When the player's health reaches zero (0) 
	# destroy it
	if health <= 0:
		destroy()
		pass
	
	# If the player presses the 'A' key
	# perform one of the following depending on the state
	if Input.is_action_just_pressed(controls.action1):
		if state == states.FIGHT:
			# If in fight mode use the sword item
			use_item(preload('res://objects/items/sword.tscn'))
		elif state == states.BREAK:
			# If in break mode send a signal to launch the ball
			emit_signal('launchBall')
		
func _physics_process(delta):
	controls_loop()
	spritedir_loop()

	# Run the loop for the apporiate state
	if state == states.BREAK:
		breakState()
	elif state == states.FIGHT:
		fightState(delta)

func breakState():
	# Move the player based on the PADDLESPEED constant
	var motion = movedir.normalized() * PADDLESPEED
	move_and_slide(motion, Vector2())
	
	# Make sure to use the break mode animations for walk/idle
	if movedir != Vector2():
		anim_switch('breakwalk')
	else:
		anim_switch('breakidle')

func fightState(delta):
	# As long as the player isn't using an item
	# they can mmove
	if not usingItem:
		movement_loop()
	damage_loop(delta)
	
	# Make sure to use the regular animations here
	if movedir != Vector2():
		anim_switch(str('walk',spritedir))
	else:
		anim_switch(str('idle', spritedir))

func controls_loop():
	var LEFT = Input.is_action_pressed(controls.dpad_left)
	var RIGHT = Input.is_action_pressed(controls.dpad_right)
	var UP = Input.is_action_pressed(controls.dpad_up)
	var DOWN = Input.is_action_pressed(controls.dpad_down)
	
	movedir.x = -int(LEFT) + int(RIGHT)
	if state == states.FIGHT:
		movedir.y = -int(UP) + int(DOWN)
	else:
		movedir.y = 0

func destroy():
	emit_signal('playerHasDied')
	print('The player has died.')
	if not inDebug:
		.destroy()

func createPaddle():
	if paddle == null:
		paddle = paddleScn.instance()
		add_child(paddle)
		paddle.position = Vector2(0,-16)

func createBall():
	var ball = ballScn.instance()
	get_parent().add_child(ball)
	get_parent().ball = ball
	ball.connectSignal(self)

func destroyPaddle():
	if paddle != null:
		paddle.queue_free()
		paddle = null

func switchToBreak(createBall=true):
	# Set player's state to break
	state = states.BREAK
	# Move player back in position
	position.y = 256
	# Tell the player to create the paddle
	createPaddle()
	# Tell the player to create the ball
	if createBall:
		createBall()
	pass

func switchToFight():
	# Set player to fight state
	state = states.FIGHT
	# Tell the player to destroy the paddle
	destroyPaddle()
	# Tell the player to destroy the ball
	pass
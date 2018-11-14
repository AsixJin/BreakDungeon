extends 'res://scripts/entity.gd'

# Scene
const paddleScn = preload('res://entities/paddle.tscn')
const ballScn = preload('res://entities/ball.tscn')

# Const
const PADDLESPEED = 70
const SPEED = 50
const TYPE = 'PLAYER'

# Signals
signal launchBall
signal playerHasDied

# Variables
var paddle = null
var state = states.BREAK
var usingItem = false

func _ready():
	createPaddle()
	pass

func _process(delta):
	if health <= 0:
		# destroy()
		pass
	
	if Input.is_action_just_pressed('a') and state == states.FIGHT:
		use_item(preload('res://objects/items/sword.tscn'))
	if Input.is_action_just_pressed('a') and state == states.BREAK:
		emit_signal('launchBall')

func _physics_process(delta):
	controls_loop()
	spritedir_loop()
	if state == states.BREAK:
		breakState()
	elif state == states.FIGHT:
		fightState(delta)

func breakState():
	# Move the paddle based on the PADDLESPEED
	var motion = movedir.normalized() * PADDLESPEED
	move_and_slide(motion, Vector2())
	
	if movedir != Vector2():
		anim_switch('breakwalk')
	else:
		anim_switch('breakidle')

func fightState(delta):
	if not usingItem:
		movement_loop()
	damage_loop(delta)
	
	if movedir != Vector2():
		anim_switch(str('walk',spritedir))
	else:
		anim_switch(str('idle', spritedir))

func controls_loop():
	var LEFT = Input.is_action_pressed('ui_left')
	var RIGHT = Input.is_action_pressed('ui_right')
	var UP = Input.is_action_pressed('ui_up')
	var DOWN = Input.is_action_pressed('ui_down')
	
	movedir.x = -int(LEFT) + int(RIGHT)
	if state == states.FIGHT:
		movedir.y = -int(UP) + int(DOWN)
	else:
		movedir.y = 0

func destroy():
	emit_signal('playerHasDied')
	print('The player has died. Game Over.')
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
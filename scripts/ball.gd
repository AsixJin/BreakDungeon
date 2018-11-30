extends RigidBody2D

const TYPE = 'BALL'

signal replaceBall

var player = null
var startPosition = Vector2(232,232)
var speed = 150
var hasLauched = false


func _ready():
	position = startPosition
	pass

func _process(delta):
	checkBounds()
	if not hasLauched:
		position.x = player.position.x

func checkBounds():
	# Reset position if any of these are true
	# The ball is out of bounds
	if position.x <= 150 or position.x >= 300:
		destroy()
		return true
	if position.y >= 260:
		destroy()
		if player != null:
			player.health -= 1
		return true
	return false

func connectSignal(ply):
	player = ply
	connect('replaceBall',player.get_parent(),'checkForBall')
	player.connect('launchBall', self, 'launch')
	pass

func destroy(replace=true):
	if replace:
		emit_signal('replaceBall')
	queue_free()

func launch():
	if not hasLauched:
		var lv=Vector2(rand_range(-200,200),-200).normalized()*speed #starting velocity, with random angle
		set_linear_velocity(lv)
		hasLauched = true

# Code from https://github.com/didier-v/breakable/blob/master/ball/ball.gd
func adjust_angle():
	#here we cheat with the angle to make the game more enjoyable
	var min_angle = 20 #below 20, it's too horizontal
	var lv=get_linear_velocity().normalized()*speed  #current velocity
	var angle = rad2deg(lv.angle_to(Vector2(1,0))) #current angle

	#bounce
	if (angle>0 and angle<min_angle):
		angle=angle-min_angle #<0
	elif (angle<0 and angle>-min_angle):
		angle=angle+min_angle #>0
	elif (angle>180-min_angle and angle<180):
		angle=angle-180+min_angle #>0
	elif (angle<-180+min_angle and angle>-180):
		angle=angle+180-min_angle #<0
	else:
		angle=0
	if angle!=0:
		lv= lv.rotated(deg2rad(angle)) # we change the angle, but keep the speed
		set_linear_velocity(lv)

func _on_Area2D_body_exited(body):
	$hitSFX.play()
	adjust_angle()

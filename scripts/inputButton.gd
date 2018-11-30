extends TouchScreenButton

export var input = 'action2'

func _ready():
	connect('pressed', self, 'onPress')
	connect('released', self, 'onRelease')
	pass

func onPress():
	Input.action_press(input)

func onRelease():
	Input.action_release(input)

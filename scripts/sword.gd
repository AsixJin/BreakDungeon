extends Node2D

var TYPE = 'ITEM'
var DAMAGE = 1

var maxamount = 1
var usetimer = 0

func _ready():
	TYPE = get_parent().TYPE
	$anim.connect('animation_finished', self, 'destroy')
	$anim.play(str('swing', get_parent().spritedir))
	if get_parent().get('usingItem') != null:
		get_parent().usingItem = true

func _process(delta):
	pass

func destroy(animation):
	if get_parent().get('usingItem') != null:
		get_parent().usingItem = false
	queue_free()
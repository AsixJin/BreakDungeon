extends KinematicBody2D

const SPEED = 0
const TYPE = null

var stuntimer = 0
export var health = 1
var movedir = Vector2()
var knockdir = Vector2()
var spritedir = 'up'

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func movement_loop():
	var motion
	if stuntimer <= 0:
		motion = movedir.normalized() * SPEED
	else:
		motion = knockdir.normalized() * SPEED * 1.5
	move_and_slide(motion, Vector2())

func spritedir_loop():
	match movedir:
		dir.LEFT:
			spritedir = 'left'
		dir.RIGHT:
			spritedir = 'right'
		dir.UP:
			spritedir = 'up'
		dir.DOWN:
			spritedir = 'down'

func damage_loop(delta):
	if stuntimer > 0:
		stuntimer -= delta
	for area in $hitbox.get_overlapping_areas():
		var body = area.get_parent()
		if stuntimer <= 0 and body.get('DAMAGE') != null and body.get('TYPE') != TYPE:
			health -= body.get('DAMAGE')
			stuntimer = 0.2
			knockdir = transform.origin - body.transform.origin

func anim_switch(animation):
	var newanim = animation
	if $anim.current_animation != newanim:
		$anim.play(newanim)

func use_item(item):
	var newitem = item.instance()
	var groupname = str(newitem.get_name(), self)
	newitem.TYPE = TYPE
	newitem.add_to_group(groupname)
	add_child(newitem)
	print(newitem.position)
	if get_tree().get_nodes_in_group(groupname).size() > newitem.maxamount:
		newitem.queue_free()
extends KinematicBody2D

# Entity's Constants
const SPEED = 0
const TYPE = null

# how much health an entity has
export var health = 1
# the entity's knock back direction
var knockdir = Vector2()
# the entity's movement direction
var movedir = Vector2()
# The entity's sprite direction
var spritedir = 'up'
# the entity's stun timer
var stuntimer = 0

# A function for when an entity needs to be destroyed
# by default we call queue_free, but by overriding (.destroy())
# you can do anything else neccesary
func destroy():
	queue_free()

# Movement loop for the entity
func movement_loop():
	var motion
	if stuntimer <= 0:
		# If the stun timer is zero (0) or below
		# the entity's motion is based on their direction and speed
		motion = movedir.normalized() * SPEED
	else:
		# If the stun timer is above zero (0)
		# we use the knock back direction for the motion
		motion = knockdir.normalized() * SPEED * 1.5
	# Once we have the motion we can apply it to the entity
	move_and_slide(motion, Vector2())

# Sprite direction loop for the entity
func spritedir_loop():
	# Check the movement direction of the entity
	# and set the sprite direction accordingly
	match movedir:
		dir.LEFT:
			spritedir = 'left'
		dir.RIGHT:
			spritedir = 'right'
		dir.UP:
			spritedir = 'up'
		dir.DOWN:
			spritedir = 'down'

# Damage loop for the entity
func damage_loop(delta):
	if stuntimer > 0:
		# If the stun timer is above zero (0)
		# run the timer by subtracting the delta time
		stuntimer -= delta
	
	# Check for any overlapping areas for the hitbox
	for area in $hitbox.get_overlapping_areas():
		# For each area found..
		# Get the body (the area's parent)
		var body = area.get_parent()
		# Check to see if all the following conditions are true
		# the stun timer is zero (0) or below
		# the body has a DAMAGE constant
		# the body's type is not the same as this entity's
		if stuntimer <= 0 and body.get('DAMAGE') != null and body.get('TYPE') != TYPE:
			# If the above conditions are true then...
			# Subtract the body's DAMAGE value from this entity's health
			health -= body.get('DAMAGE')
			# Add time to the stun timer
			stuntimer = 0.2
			# Set the knock back direction for the entity
			knockdir = transform.origin - body.transform.origin

# Switch the entity's current animation to the one given
func anim_switch(animation):
	var newanim = animation
	if $anim.current_animation != newanim:
		# If the animation given is not the one playing
		# Switch to that animation
		$anim.play(newanim)

# Allows an entity to use items
func use_item(item):
	# Create the item
	var newitem = item.instance()
	# Generate the group name for the item
	# The group name is the name of the item combined with the entity's name
	var groupname = str(newitem.get_name(), self)
	# Set the item's type to the type of this entity
	newitem.TYPE = TYPE
	# Add it to its generated group
	newitem.add_to_group(groupname)
	# Add the item as a child of the entity
	add_child(newitem)
	# Check the itme's group and see how many are in this group
	if get_tree().get_nodes_in_group(groupname).size() > newitem.maxamount:
		# If the amount of items in the group is greater than the item's max
		# amount then destroy the newly created item
		newitem.queue_free()
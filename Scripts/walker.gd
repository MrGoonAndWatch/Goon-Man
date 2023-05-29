extends CharacterBody2D

const SPEED = 25.0

var direction = 1
var last_direction = 0
var paused = false

@onready var ledge_check_left: = $LedgeCheckLeft
@onready var ledge_check_right: = $LedgeCheckRight

@onready var sprite: = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	sprite.play("Walking")

func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		paused = !paused
	
	if paused:
		return
	
	if is_on_wall() or _about_to_walk_off_ledge():
		direction *= -1
	
	_update_direction_sprite()
	
	#if not is_on_floor():
	#	velocity.y += gravity * delta
	
	velocity.x = direction * SPEED
	
	# velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _update_direction_sprite():
	if not direction == last_direction:
		last_direction = direction
		if direction > 0:
			sprite.set_flip_h(true)
		else:
			sprite.set_flip_h(false)

func _about_to_walk_off_ledge():
	return not ledge_check_left.is_colliding() or not ledge_check_right.is_colliding()

func damage():
	queue_free()

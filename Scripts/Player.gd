extends CharacterBody2D


const SPEED = 150.0

const JUMP_VELOCITY_START = -200.0
const JUMP_VELOCITY_ADD = -25.0
const MAX_JUMP_VELOCITY = -250.0

var dead = false
var jumping = false
var current_dir = 1

var max_bullets = 3
var spawned_bullets = []

@export var bullet_scene: PackedScene
@export var bullet_manager: NodePath

@onready var sprite: = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if dead:
		return
		
	if position.y > (get_tree().get_root().size.y) / 2:
		_die()
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY_START
		jumping = true
	elif jumping and Input.is_action_pressed("ui_accept") and velocity.y > MAX_JUMP_VELOCITY:
		velocity.y += JUMP_VELOCITY_ADD
	else:
		jumping = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		_update_direction(direction)
		current_dir = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _update_direction(direction):
	if(direction == current_dir):
		return
	
	if direction > 0:
		sprite.set_flip_h(true)
	else:
		sprite.set_flip_h(false)

func _die():
	if dead:
		return
	
	dead = true
	print("oh i die")
	hide()

func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		_shoot()

func _shoot():
	if get_node(bullet_manager).get_child_count() >= max_bullets:
		return
	
	var new_bullet = bullet_scene.instantiate()
	new_bullet.initialize(position, current_dir)
	get_node(bullet_manager).add_bullet(new_bullet)
	spawned_bullets.push_back(new_bullet)

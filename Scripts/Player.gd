extends CharacterBody2D


const SPEED = 150.0

const JUMP_VELOCITY_START = -200.0
const JUMP_VELOCITY_ADD = -25.0
const MAX_JUMP_VELOCITY = -250.0

var dead = false
var jumping = false
var current_dir = 1
var paused = false
var won = false

var hp = 3
signal health_changed(new_hp)

var hurt_time_remaining = 0.0
var iframes_remaining = 0.0
const HURT_TIME = 1.0
const IFRAMES = 2.0
const HURT_KNOCKBACK_VELOCITY = 25.0

var max_bullets = 3
var spawned_bullets = []

@export var bullet_scene: PackedScene
@export var bullet_manager: NodePath

@onready var sprite: = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta):
	if iframes_remaining > 0:
		self.modulate.a = 0.5 if Engine.get_frames_drawn() % 8 == 0 else 1.0
	else:
		self.modulate.a = 1.0

func _physics_process(delta):
	if dead or won:
		return
	
	if Input.is_action_just_pressed("pause"):
		paused = !paused
	
	if not paused:
		if position.y > (get_tree().get_root().size.y) / 2:
			_die()
	
		_update_hurt_frames(delta)
		_update_iframes(delta)
		_update_gravity(delta)
		_update_jump()
		_update_player_movement()

		move_and_slide()

func _update_hurt_frames(delta):
	if hurt_time_remaining == 0:
		return
		
	hurt_time_remaining -= delta
	if hurt_time_remaining < 0:
		print("hurt time is done!")
		hurt_time_remaining = 0
	
func _update_iframes(delta):
	if iframes_remaining == 0:
		return
		
	iframes_remaining -= delta
	if iframes_remaining < 0:
		print("iframes are done!")
		iframes_remaining = 0

func _update_jump():
	if hurt_time_remaining > 0:
		jumping = false
		return
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY_START
		jumping = true
	elif jumping and Input.is_action_pressed("jump") and velocity.y > MAX_JUMP_VELOCITY:
		velocity.y += JUMP_VELOCITY_ADD
	else:
		jumping = false
		
func _update_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func _update_direction(direction):
	if direction == current_dir:
		return
	
	if direction > 0:
		sprite.set_flip_h(true)
	else:
		sprite.set_flip_h(false)

func _update_player_movement():
	var direction = Input.get_axis("left", "right")
	if direction and hurt_time_remaining == 0:
		velocity.x = direction * SPEED
		_update_direction(direction)
		current_dir = direction
	elif hurt_time_remaining == 0:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = current_dir * -1 * HURT_KNOCKBACK_VELOCITY

func _can_be_hurt():
	return not dead and iframes_remaining == 0

func _hurt(damage):
	if iframes_remaining > 0:
		return
	
	print("took " + str(damage) + " damage")
	
	hp -= damage
	health_changed.emit(hp)
	
	if hp <= 0:
		_die()
	else:
		hurt_time_remaining = HURT_TIME
		iframes_remaining = IFRAMES

func _die():
	if dead:
		return
	
	health_changed.emit(0)
	dead = true
	print("oh i die")
	sprite.hide()
	
func _is_dead():
	return dead

func _win():
	print("oh I win!")
	won = true

func _has_won():
	return won

func _unhandled_input(event):
	if paused or won:
		return
	
	if event.is_action_pressed("shoot"):
		_shoot()

func _shoot():
	if get_node(bullet_manager).get_child_count() >= max_bullets:
		return
	
	var new_bullet = bullet_scene.instantiate()
	new_bullet.initialize(position, current_dir)
	get_node(bullet_manager).add_bullet(new_bullet)
	spawned_bullets.push_back(new_bullet)

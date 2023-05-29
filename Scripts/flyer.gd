extends CharacterBody2D

const SPEED = 50.0

@export var move_right_at_start: bool = true
@export var distance: int = 5

@onready var sprite: = $AnimatedSprite2D

var current_dir = 0
var last_dir = 0
var time_until_turnaround = 0
var paused = false

func _ready():
	current_dir = 1 if move_right_at_start else -1
	_update_direction()
	time_until_turnaround = distance
	sprite.play("flying")

func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		paused = !paused
	
	if paused:
		return
	
	time_until_turnaround -= delta
	
	if is_on_wall() or time_until_turnaround <= 0:
		current_dir *= -1
		time_until_turnaround = distance
	
	_update_direction()
	
	velocity.x = current_dir * SPEED

	move_and_slide()

func _update_direction():
	if not current_dir == last_dir:
		last_dir = current_dir
		if current_dir > 0:
			sprite.set_flip_h(true)
		else:
			sprite.set_flip_h(false)

func damage():
	queue_free()

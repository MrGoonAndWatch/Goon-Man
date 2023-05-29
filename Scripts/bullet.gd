extends Area2D

const SPEED = 2.5

var direction = 0
var initialized = false
var paused = false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		paused = !paused
	
	if not initialized or paused:
		return
	
	position.x += direction * SPEED

func kill():
	queue_free()

func initialize(startPos: Vector2, move_dir: int):
	position = startPos
	direction = move_dir
	initialized = true

func on_collision(collider):
	if collider.is_in_group("damagable"):
		collider.damage()
	kill()

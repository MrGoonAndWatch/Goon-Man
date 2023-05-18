extends Area2D

const SPEED = 10

var direction = 0
var initialized = false

func _process(delta):
	if not initialized:
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

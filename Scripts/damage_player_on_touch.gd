extends Area2D

@export var damage: int = 1

var waiting_to_damage_player = false
var player

func _process(delta):
	if waiting_to_damage_player and player._can_be_hurt():
		player._hurt(damage)

func on_collision(collider):
	if collider.is_in_group("player"):
		if collider._can_be_hurt():
			collider._hurt(damage)
		else:
			player = collider
			waiting_to_damage_player = true

func on_collision_end(collider):
	if collider.is_in_group("player"):
		waiting_to_damage_player = false


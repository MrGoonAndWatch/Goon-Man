extends Area2D

func _on_collide(collision):
	print("collision!")
	if collision.is_in_group("player"):
		collision._win()

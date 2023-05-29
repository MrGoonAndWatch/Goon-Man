extends Node

@export var heart1: NodePath
@export var heart2: NodePath
@export var heart3: NodePath

func _on_health_changed(new_hp):
	# Warning: this code sucks lmao
	if new_hp >= 3:
		get_node(heart3)._gain_heart()
	else:
		get_node(heart3)._lose_heart()
	
	if new_hp >= 2:
		get_node(heart2)._gain_heart()
	else:
		get_node(heart2)._lose_heart()
	
	if new_hp >= 1:
		get_node(heart1)._gain_heart()
	else:
		get_node(heart1)._lose_heart()

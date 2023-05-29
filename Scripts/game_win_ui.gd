extends ColorRect

@export var player: NodePath
var player_node
var displayed = false

func _ready():
	player_node = get_node(player)
	hide()

func _process(delta):
	if displayed:
		return
	
	if player_node._has_won():
		show()
		displayed = true

func _on_play_again():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

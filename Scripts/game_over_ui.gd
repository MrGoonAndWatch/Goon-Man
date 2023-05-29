extends ColorRect

var displayed = false
@export var player: NodePath
var playerNode

func _ready():
	playerNode = get_node(player)
	hide()

func _process(delta):
	if displayed:
		return
	
	if playerNode._is_dead():
		print("player died!")
		show()
		displayed = true

func _on_retry():
	get_tree().reload_current_scene()

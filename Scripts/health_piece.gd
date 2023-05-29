extends Node

@export var active: NodePath
@export var inactive: NodePath

func _ready():
	_gain_heart()

func _lose_heart():
	get_node(active).hide()
	get_node(inactive).show()

func _gain_heart():
	get_node(inactive).hide()
	get_node(active).show()

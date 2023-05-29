extends ColorRect

var ui_shown = false

func _ready():
	hide()

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		ui_shown = !ui_shown
		if ui_shown:
			show()
		else:
			hide()

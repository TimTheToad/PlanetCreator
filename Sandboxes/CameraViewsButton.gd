extends Button

onready var buttons = get_node("ButtonContainer")

func _on_CameraViewsButton_toggled(button_pressed):
	buttons.visible = button_pressed
	pass # Replace with function body.

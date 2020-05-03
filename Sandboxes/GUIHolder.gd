extends Control

func _ready():
	for child in self.get_children():
		child.connect("mouse_entered", self, "_mouseEnteredGUI")
		child.connect("mouse_exited", self, "_mouseExitedGUI")
		
func _mouseEnteredGUI():
	print("mouse entered")
	
func _mouseExitedGUI():
	print("mouse exited")

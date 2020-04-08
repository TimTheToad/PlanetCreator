extends Button


export(int) var parentsToClimb;

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", self, "_on_ExitButton_pressed")
	pass # Replace with function body.




func _on_ExitButton_pressed():
	var parent = self.get_parent();
	for i in range(parentsToClimb - 1):
		parent = parent.get_parent()
	
	parent.set_visible(false)
	pass # Replace with function body.



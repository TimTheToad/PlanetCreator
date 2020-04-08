extends Tabs


# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_child(0).connect("color_changed", self, "callback")
	
	pass # Replace with function body.

func callback(value):
	var text = self.name
	emit_signal("updated", text, value)

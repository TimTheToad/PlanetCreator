extends Tabs


# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_node("VBoxContainer/ColorPicker").connect("color_changed", self, "color_callback")
	self.get_node("VBoxContainer/Button").connect("pressed", self, "random_callback")
	
	pass # Replace with function body.

func color_callback(value):
	var text = self.name
	emit_signal("updated", text, value)

func random_callback():
	var text = self.name
	emit_signal("random", text)

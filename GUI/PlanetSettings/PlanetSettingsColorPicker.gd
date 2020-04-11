extends Tabs

var param = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_node("VBoxContainer/ColorPicker").connect("color_changed", self, "color_callback")
	self.get_node("VBoxContainer/Button").connect("pressed", self, "random_callback")
	
	pass # Replace with function body.

func color_callback(value):
	emit_signal("updated", param, value)

func random_callback():
	emit_signal("random", param)

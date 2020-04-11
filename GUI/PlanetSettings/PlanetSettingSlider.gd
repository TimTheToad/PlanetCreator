extends HBoxContainer

var param = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_child(1).connect("value_changed", self, "slider_callback")
	
	pass # Replace with function body.

func slider_callback(value):
	emit_signal("updated", param, value)

func setText(text):
	self.get_child(0).text = text

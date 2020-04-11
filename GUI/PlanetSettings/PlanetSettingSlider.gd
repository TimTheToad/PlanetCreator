extends HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_child(1).connect("value_changed", self, "slider_callback")
	
	pass # Replace with function body.

func slider_callback(value):
	var label = get_child(0)
	emit_signal("updated", label.text, value)

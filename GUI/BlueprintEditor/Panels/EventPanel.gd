extends Button


var layerEvent

func init(text, event):
	self.set_text(text)
	self.layerEvent = event

	pass


func _on_EventPanel_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			self.emit_signal("eventSelected", self)

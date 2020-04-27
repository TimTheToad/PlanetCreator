extends PanelContainer

onready var label = get_node("HBoxContainer/Label")
onready var colorRect = get_node("HBoxContainer/ColorRect")

var layerEvent

var _pressedColor
var _normalColor

func init(text, event):
	label.set_text(text)
	self.layerEvent = event

			
#	_pressedColor = self.color * 0.5
#	_normalColor = self.color
	pass

func selected(isSelected):
#	if isSelected:
#		self.color = _pressedColor
#	else:
#		self.color = _normalColor
	pass

func _on_EventPanel_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			self.emit_signal("eventSelected", self)

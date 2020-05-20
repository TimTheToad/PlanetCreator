extends ColorRect

onready var eventPanel = preload("res://GUI/BlueprintEditor/Panels/EventPanel.tscn")
onready var container = get_node("ScrollContainer/VBoxContainer")
onready var label = get_node("Base/HBoxContainer/Label")
onready var LayerIcon = get_node("Base/HBoxContainer/LayerIcon")

var mLayer

enum PanelType {
	FILL,
	NOISE
}

func setIcon(tex):
	LayerIcon.texture = tex

func setLabel(text):
	label.set_text(text)

func setLayer(layer):
	self.mLayer = layer

func getLayer():
	return mLayer

func addPanel(event):
	var p
	match event.type:
		PanelType.FILL:
			p = eventPanel.instance()
			container.add_child(p)
			p.init("Fill", event)
			p.icon = load("res://Assets/Icons/EventIcons/fill.png")
		PanelType.NOISE:
			p = eventPanel.instance()
			container.add_child(p)
			p.init("Noise", event)
			p.icon = load("res://Assets/Icons/EventIcons/noise.png")
	
	return p

var _pressedColor = self.color * 0.5
var _normalColor = self.color

func selected(isSelected):
	if isSelected:
		self.color = _pressedColor
	else:
		self.color = _normalColor

func _on_LayerPanel_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			self.emit_signal("selected", self)
	pass # Replace with function body.

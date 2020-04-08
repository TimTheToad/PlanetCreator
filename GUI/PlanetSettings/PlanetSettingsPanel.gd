extends WindowDialog

onready var Planet = get_parent().get_parent().get_child(1);

export(PackedScene) var sliderScene;
export(PackedScene) var colorTabScene;
onready var sliderContainer = get_node("Panel/MarginContainer/VSplitContainer/Tabs/TabContainer/Sliders/VBoxContainer")
onready var colorContainer = get_node("Panel/MarginContainer/VSplitContainer/Tabs/TabContainer/Colors/TabContainer")

func _ready():
	self._createSlider()
	self._createColorPickers()
	pass # Replace with function body.

func showWindow():
	self.popup_centered()

func _createColorPickers():
	if colorTabScene:
		var params = Planet.getPlanetAttributeNames()[1]
		
		for name in params:
			var instance = colorTabScene.instance()
			instance.name = name
			var colorPickerNode = instance.get_child(0)
			colorPickerNode.color = Planet.getPlanetAttribute(name)
			colorPickerNode.edit_alpha = false
			colorPickerNode.raw_mode = true
			# Add signal to slider
			instance.add_user_signal("updated", [["param", TYPE_STRING], ["value", TYPE_COLOR]])
			instance.connect("updated", self, "_sliderUpdateParam")
			
			colorContainer.add_child(instance)
	pass

func _createSlider():
	if sliderScene:
		var sliders = Planet.getPlanetAttributeNames()[0]
		
		for name in sliders:
			var instance = sliderScene.instance()
			instance.get_child(0).text = name
			var sliderNode = instance.get_child(1)
			sliderNode.value = Planet.getPlanetAttribute(name)
			
			# Add signal to slider
			instance.add_user_signal("updated", [["param", TYPE_STRING], ["value", TYPE_REAL]])
			instance.connect("updated", self, "_sliderUpdateParam")
			
			sliderContainer.add_child(instance)
		
func _sliderUpdateParam(param, value):
	Planet.setPlanetAttribute(param, value)

extends WindowDialog

onready var Planet = get_parent().get_parent().get_child(1);

export(PackedScene) var sliderScene;
onready var sliderContainer = get_node("Panel/MarginContainer/VSplitContainer/Tabs/TabContainer/Sliders/VBoxContainer")

func _ready():
	self.popup_centered()
	self._createSlider()
	pass # Replace with function body.

func _createSlider():
	if sliderScene:
		var sliders = Planet.getPlanetAttributeNames()[0]
		
		for name in sliders:
			var instance = sliderScene.instance()
			instance.get_child(0).text = name
			var sliderNode = instance.get_child(1)
			sliderNode.value = 
			sliderContainer.add_child(instance)
		

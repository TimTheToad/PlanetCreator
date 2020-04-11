extends WindowDialog

onready var Planet = get_parent().get_parent().get_child(1);

export(PackedScene) var sliderScene;
export(PackedScene) var colorTabScene;

onready var terrainTab = self.get_child(1)
onready var waterTab = self.get_child(1)

func _ready():
	terrainTab = self.get_node("Panel/MarginContainer/TabContainer/Terrain")
	waterTab = self.get_node("Panel/MarginContainer/TabContainer/Water")
	
	self._createSlider()
	self._createColorPickers()
	pass # Replace with function body.

func showWindow():
	self.popup_centered()

func _createColorPickers():
	if colorTabScene:
		# Terrain Settings
		var params = Planet.getTerrainAttributeNames()[1]
		var colorContainer = terrainTab.get_child(0).get_child(1).get_child(0)
		for i in range(params[0].size()):
			var instance = colorTabScene.instance()
			instance.param = params[0][i]
			instance.name = params[1][i]
			var colorPickerNode = instance.get_child(0).get_child(0)
			colorPickerNode.color = Planet.getPlanetAttribute(instance.param)
			colorPickerNode.edit_alpha = false
			colorPickerNode.raw_mode = true
			# Add signal to slider
			instance.add_user_signal("updated", [["param", TYPE_STRING], ["value", TYPE_COLOR]])
			instance.connect("updated", self, "_TerrainUpdateParam")
			
			instance.add_user_signal("random", [["param", TYPE_STRING]])
			instance.connect("random", self, "_TerrainRandomizeParam")
			
			colorContainer.add_child(instance)
			
		params = Planet.getWaterAttributeNames()[1]
		colorContainer = waterTab.get_child(0).get_child(1).get_child(0)
		for i in range(params[0].size()):
			var instance = colorTabScene.instance()
			instance.param = params[0][i]
			instance.name = params[1][i]
			var colorPickerNode = instance.get_child(0).get_child(0)
			colorPickerNode.color = Planet.getPlanetAttribute(instance.param)
			colorPickerNode.edit_alpha = false
			colorPickerNode.raw_mode = true
			# Add signal to slider
			instance.add_user_signal("updated", [["param", TYPE_STRING], ["value", TYPE_COLOR]])
			instance.connect("updated", self, "_WaterUpdateParam")
			
			instance.add_user_signal("random", [["param", TYPE_STRING]])
			instance.connect("random", self, "_WaterRandomizeParam")
			
			colorContainer.add_child(instance)
	pass

func _createSlider():
	if sliderScene:
		var sliders = Planet.getTerrainAttributeNames()[0]
		var sliderContainer = terrainTab.get_child(0).get_child(0).get_child(0)
		for i in range(sliders[0].size()):
			var instance = sliderScene.instance()
			instance.param = sliders[0][i]
			instance.setText(sliders[1][i])
			var sliderNode = instance.get_child(1)
			sliderNode.value = Planet.getPlanetAttribute(instance.param)
			
			# Add signal to slider
			instance.add_user_signal("updated", [["param", TYPE_STRING], ["value", TYPE_REAL]])
			instance.connect("updated", self, "_TerrainUpdateParam")
			
			sliderContainer.add_child(instance)
		
		sliders = Planet.getWaterAttributeNames()[0]
		sliderContainer = waterTab.get_child(0).get_child(0).get_child(0)
		for i in range(sliders[0].size()):
			var instance = sliderScene.instance()
			instance.param = sliders[0][i]
			instance.setText(sliders[1][i])
			var sliderNode = instance.get_child(1)
			sliderNode.value = Planet.getPlanetAttribute(instance.param)
			
			# Add signal to slider
			instance.add_user_signal("updated", [["param", TYPE_STRING], ["value", TYPE_REAL]])
			instance.connect("updated", self, "_WaterUpdateParam")
			
			sliderContainer.add_child(instance)
			

func _TerrainRandomizeParam(param):
	Planet.randomisePlanetAttribute(param, Planet.PLANET_MAT.TERRAIN)

func _WaterRandomizeParam(param):
	Planet.randomiseWaterAttribute(param, Planet.PLANET_MAT.WATER)

func _TerrainUpdateParam(param, value):
	Planet.setPlanetAttribute(param, value)

func _WaterUpdateParam(param, value):
	Planet.setPlanetAttribute(param, value)

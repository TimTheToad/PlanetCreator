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
		for name in params:
			var instance = colorTabScene.instance()
			instance.name = name
			var colorPickerNode = instance.get_child(0)
			colorPickerNode.color = Planet.getPlanetAttribute(name, Planet.PLANET_MAT.TERRAIN)
			colorPickerNode.edit_alpha = false
			colorPickerNode.raw_mode = true
			# Add signal to slider
			instance.add_user_signal("updated", [["param", TYPE_STRING], ["value", TYPE_COLOR]])
			instance.connect("updated", self, "_TerrainUpdateParam")
			
			colorContainer.add_child(instance)
			
		params = Planet.getWaterAttributeNames()[1]
		colorContainer = waterTab.get_child(0).get_child(1).get_child(0)
		for name in params:
			var instance = colorTabScene.instance()
			instance.name = name
			var colorPickerNode = instance.get_child(0)
			colorPickerNode.color = Planet.getPlanetAttribute(name, Planet.PLANET_MAT.WATER)
			colorPickerNode.edit_alpha = false
			colorPickerNode.raw_mode = true
			# Add signal to slider
			instance.add_user_signal("updated", [["param", TYPE_STRING], ["value", TYPE_COLOR]])
			instance.connect("updated", self, "_WaterUpdateParam")
			
			colorContainer.add_child(instance)
	pass

func _createSlider():
	if sliderScene:
		var sliders = Planet.getTerrainAttributeNames()[0]
		var sliderContainer = terrainTab.get_child(0).get_child(0).get_child(0)
		for name in sliders:
			var instance = sliderScene.instance()
			instance.get_child(0).text = name
			var sliderNode = instance.get_child(1)
			sliderNode.value = Planet.getPlanetAttribute(name, Planet.PLANET_MAT.TERRAIN)
			
			# Add signal to slider
			instance.add_user_signal("updated", [["param", TYPE_STRING], ["value", TYPE_REAL]])
			instance.connect("updated", self, "_TerrainUpdateParam")
			
			instance.add_user_signal("randomise", [["param", TYPE_STRING]])
			instance.connect("randomise", self, "_TerrainRandomizeParam")
			
			sliderContainer.add_child(instance)
		
		sliders = Planet.getWaterAttributeNames()[0]
		sliderContainer = waterTab.get_child(0).get_child(0).get_child(0)
		for name in sliders:
			var instance = sliderScene.instance()
			instance.get_child(0).text = name
			var sliderNode = instance.get_child(1)
			sliderNode.value = Planet.getPlanetAttribute(name, Planet.PLANET_MAT.WATER)
			
			# Add signal to slider
			instance.add_user_signal("updated", [["param", TYPE_STRING], ["value", TYPE_REAL]])
			instance.connect("updated", self, "_WaterUpdateParam")
			
			instance.add_user_signal("randomise", [["param", TYPE_STRING]])
			instance.connect("randomise", self, "_WaterRandomizeParam")
			
			sliderContainer.add_child(instance)
			

func _TerrainRandomizeParam(param):
	Planet.randomisePlanetAttribute(param, Planet.PLANET_MAT.TERRAIN)

func _WaterRandomizeParam(param):
	Planet.randomiseWaterAttribute(param, Planet.PLANET_MAT.WATER)

func _TerrainUpdateParam(param, value):
	Planet.setPlanetAttribute(param, value, Planet.PLANET_MAT.TERRAIN)

func _WaterUpdateParam(param, value):
	Planet.setPlanetAttribute(param, value, Planet.PLANET_MAT.WATER)

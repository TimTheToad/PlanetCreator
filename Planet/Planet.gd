extends Spatial

enum PLANET_MAT{
  TERRAIN,
  WATER
}

var waterInstance
var waterMaterial

var terrainInstance
var terrainMaterial
var terrainTexture
var terrainNoise

export(int) var offsetFromSun

var historyPanel 
var tempHistory
var planetHistory = []

var updated = false

var terrainColorAttributes = [
	["sand_color", "ground_color", "mountain_color", "snow_color"],
	["Sand", "Ground", "Mountain", "Snow"],
	]
var terrainSliderAttributes = [
	["terrain_magnitude", "sand_amount", "mountain_amount", "snow_amount"],
	["Magnitude", "Sand Threshold", "Mountain Threshold", "Snow Threshold"],
	]
	
var waterColorAttributes = [["water_color"], ["Water"]]
var waterSliderAttributes = [
	["water_magnitude", "wave_speed", "wave_height"],
	["Magnitude", "Wave speed", "Wave height"]
	]


# Called when the node enters the scene tree for the first time.
func _ready():
	_PlanetInitilise()
	pass # Replace with function body.

func randomisePlanetAttribute(name, material = PLANET_MAT.TERRAIN):
	if !updated:
		AddHistoryItem(name)
	
	if material == PLANET_MAT.TERRAIN:
		if terrainColorAttributes[0].count(name) > 0:
			terrainMaterial.set_shader_param(name, Color(randf(), randf(), randf(), 0))
		elif terrainSliderAttributes[0].count(name) > 0:
			terrainMaterial.set_shader_param(name, randf())
	elif material == PLANET_MAT.WATER:
		if waterColorAttributes[0].count(name) > 0:
			terrainMaterial.set_shader_param(name, Color(randf(), randf(), randf(), 0))
		elif waterSliderAttributes[0].count(name) > 0:
			terrainMaterial.set_shader_param(name, randf())
	
func randomiseWaterAttribute(name, material = PLANET_MAT.TERRAIN):
	if !updated:
		AddHistoryItem(name)
	
	if material == PLANET_MAT.TERRAIN:
		if terrainColorAttributes[0].count(name) > 0:
			waterMaterial.set_shader_param(name, Color(randf(), randf(), randf(), 0))
		elif terrainSliderAttributes[0].count(name) > 0:
			waterMaterial.set_shader_param(name, randf())
	elif material == PLANET_MAT.WATER:
		if waterColorAttributes[0].count(name) > 0:
			waterMaterial.set_shader_param(name, Color(randf(), randf(), randf(), 0))
		elif waterSliderAttributes[0].count(name) > 0:
			waterMaterial.set_shader_param(name, randf())

func getPlanetAttribute(name):
	
	var  material = PLANET_MAT.TERRAIN
	if waterColorAttributes[0].count(name) > 0 or waterSliderAttributes[0].count(name):
		material = PLANET_MAT.WATER
		
	if material == PLANET_MAT.TERRAIN:
		return terrainMaterial.get_shader_param(name)
	elif material == PLANET_MAT.WATER:
		return waterMaterial.get_shader_param(name)
	pass

func setPlanetAttribute(name, value):
	if !updated:
		AddHistoryItem(name)
	
	var  material = PLANET_MAT.TERRAIN
	if waterColorAttributes[0].count(name) > 0 or waterSliderAttributes[0].count(name):
		material = PLANET_MAT.WATER
	
	if material == PLANET_MAT.TERRAIN:
		terrainMaterial.set_shader_param(name, value)
	elif material == PLANET_MAT.WATER:
		waterMaterial.set_shader_param(name, value)


func _setPlanetAttribute(name, value):	
	var  material = PLANET_MAT.TERRAIN
	if waterColorAttributes[0].count(name) > 0 or waterSliderAttributes[0].count(name):
		material = PLANET_MAT.WATER
	
	if material == PLANET_MAT.TERRAIN:
		terrainMaterial.set_shader_param(name, value)
	elif material == PLANET_MAT.WATER:
		waterMaterial.set_shader_param(name, value)

func getTerrainAttributeNames():
	return [terrainSliderAttributes, terrainColorAttributes];
	
func getWaterAttributeNames():
	return [waterSliderAttributes, waterColorAttributes];

func _PlanetInitilise():
	terrainInstance = get_node("PlanetMesh")
	waterInstance = get_node("WaterMesh")
	self.translate(Vector3(offsetFromSun, 0, 0))
	waterMaterial = waterInstance.get_surface_material(0)
	
	terrainMaterial = terrainInstance.get_surface_material(0)
	terrainTexture = terrainMaterial.get_shader_param("heightmap")
	#terrainNoise = terrainTexture.noise


func _process(delta):
	self.rotate_y(PI*0.02 * delta)
	
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			updated = false
			
	if event is InputEventKey:
		if event.is_action_pressed("Undo") and !event.echo:
			RemoveHistoryItem()
			
func AddHistoryItem(name):
	var oldValue  = getPlanetAttribute(name)
	tempHistory = [name, oldValue]
	historyPanel = self.get_parent().get_child(2).get_child(1)
	historyPanel.AddHistoryItem(name)
	planetHistory.append(tempHistory)
	updated = true
#	print(planetHistory)
	pass

func RemoveHistoryItem():
	if planetHistory.size() > 0:
		var tempHistory = planetHistory.pop_back()
#		print(tempHistory)
#		print(planetHistory)
		_setPlanetAttribute(tempHistory[0], tempHistory[1])
		historyPanel = self.get_parent().get_child(2).get_child(1)
		historyPanel.RemoveHistoryItem()
	

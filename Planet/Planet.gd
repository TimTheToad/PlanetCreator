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

var tempHistory
var planetHistory = []

var updated = false

var terrainColorAttributes = ["sand_color", "ground_color", "mountain_color", "snow_color"]
var terrainSliderAttributes = ["slider", "sand_amount", "mountain_amount", "snow_amount"]
var waterColorAttributes = ["water_color"]
var waterSliderAttributes = ["slider", "wave_speed", "wave_height"]

# Called when the node enters the scene tree for the first time.
func _ready():
	_PlanetInitilise()
	pass # Replace with function body.

func randomisePlanetAttribute(name, material = PLANET_MAT.TERRAIN):
	if material == PLANET_MAT.TERRAIN:
		if terrainColorAttributes.count(name) > 0:
			terrainMaterial.set_shader_param(name, Color(randf(), randf(), randf(), 0))
		elif terrainSliderAttributes.count(name) > 0:
			terrainMaterial.set_shader_param(name, randf())
	elif material == PLANET_MAT.WATER:
		if waterColorAttributes.count(name) > 0:
			terrainMaterial.set_shader_param(name, Color(randf(), randf(), randf(), 0))
		elif waterSliderAttributes.count(name) > 0:
			terrainMaterial.set_shader_param(name, randf())
	
func randomiseWaterAttribute(name, material = PLANET_MAT.TERRAIN):
	if material == PLANET_MAT.TERRAIN:
		if terrainColorAttributes.count(name) > 0:
			waterMaterial.set_shader_param(name, Color(randf(), randf(), randf(), 0))
		elif terrainSliderAttributes.count(name) > 0:
			waterMaterial.set_shader_param(name, randf())
	elif material == PLANET_MAT.WATER:
		if waterColorAttributes.count(name) > 0:
			waterMaterial.set_shader_param(name, Color(randf(), randf(), randf(), 0))
		elif waterSliderAttributes.count(name) > 0:
			waterMaterial.set_shader_param(name, randf())

func getPlanetAttribute(name, material = PLANET_MAT.TERRAIN):
	if material == PLANET_MAT.TERRAIN:
		return terrainMaterial.get_shader_param(name)
	elif material == PLANET_MAT.WATER:
		return waterMaterial.get_shader_param(name)
	pass

func setPlanetAttribute(name, value, material = PLANET_MAT.TERRAIN):
	tempHistory = [name, value]
	updated = true
	
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
	
	waterMaterial = waterInstance.get_surface_material(0)
	
	terrainMaterial = terrainInstance.get_surface_material(0)
	terrainTexture = terrainMaterial.get_shader_param("heightmap")
	#terrainNoise = terrainTexture.noise

	
func _process(delta):
	self.rotate_y(PI*0.02 * delta)
	
func _input(event):
	if event is InputEventMouseButton:
		if !event.pressed:
			if(updated):
				planetHistory.append(tempHistory)
				updated = false

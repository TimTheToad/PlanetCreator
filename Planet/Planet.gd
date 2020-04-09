extends Spatial

var planetMaterial;
var terrainTexture
var terrainNoise
var tempHistory
var planetInstance
var updated = false

var planetColorAttributes = ["water_color", "ground_color", "mountain_color", "snow_color"]
var planetSliderAttributes = ["slider", "water_amount", "mountain_amount", "snow_amount"]
var planetHistory = [[]]

# Called when the node enters the scene tree for the first time.
func _ready():
	_PlanetInitilise()
	pass # Replace with function body.

func getPlanetAttribute(name):
	return planetMaterial.get_shader_param(name)

func setPlanetAttribute(name, value):
	tempHistory = [name, value]
	updated = true
	planetMaterial.set_shader_param(name, value)

	
func getPlanetAttributeNames():
	return [planetSliderAttributes, planetColorAttributes];

func _PlanetInitilise():
	planetInstance = get_node("PlanetMesh")
	
	var radius = 1.0
	planetInstance.mesh.radius = radius
	planetInstance.mesh.height = radius * 2.0
	
	planetMaterial = planetInstance.get_surface_material(0)
	terrainTexture = planetMaterial.get_shader_param("heightmap")
	#terrainNoise = terrainTexture.noise

	
func _process(delta):
	self.rotate_y(PI*0.02 * delta)
	
func _input(event):
	if event is InputEventMouseButton:
		if !event.pressed:
			if(updated):
				planetHistory.append(tempHistory)
				print(planetHistory)
				updated = false

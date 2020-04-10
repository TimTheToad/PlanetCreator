extends Spatial

var planetMaterial;
var terrainTexture
var terrainNoise
var tempHistory
var planetInstance
var updated = false
var historyPanel 
var planetColorAttributes = ["water_color", "ground_color", "mountain_color", "snow_color"]
var planetSliderAttributes = ["slider", "water_amount", "mountain_amount", "snow_amount"]
var planetHistory = []


# Called when the node enters the scene tree for the first time.
func _ready():
	_PlanetInitilise()
	pass # Replace with function body.

func getPlanetAttribute(name):
	return planetMaterial.get_shader_param(name)

func setPlanetAttribute(name, value):
	if !updated:
		AddHistoryItem(name)
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
			updated = false
			
	if event is InputEventKey:
		if event.is_action_pressed("Undo") and !event.echo:
			RemoveHistoryItem()
			
func AddHistoryItem(name):
	var oldValue  = planetMaterial.get_shader_param(name)
	tempHistory = [name, oldValue]
	historyPanel = self.get_parent().get_child(2).get_child(1)
	historyPanel.AddHistoryItem(name)
	planetHistory.append(tempHistory)
	updated = true
	pass

func RemoveHistoryItem():
	if planetHistory.size() > 0:
		var tempHistory = planetHistory.pop_back()
		#print(tempHistory)
		#print(planetHistory)
		planetMaterial.set_shader_param(tempHistory[0], tempHistory[1])

	

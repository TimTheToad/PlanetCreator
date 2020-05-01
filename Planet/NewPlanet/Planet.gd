extends Spatial


var phi = 0.0
var orbitSpeed = randf() / 10
var axisRotateSpeed = 0.1

var minor_axis = 10
var major_axis = 10
var position

var xArrow
var zArrow

var gotCamera = false
var offset
var cameraHolder
var camera
var unPos
var shouldOrbit
var orbitMesh
var vertexCount = 20



func _ready():
	_randomizeName()
	cameraHolder = get_tree().current_scene.get_node("CameraHolderMaster")
	shouldOrbit = false
	
	createArrows()
	
	self.position = Vector3(cos(phi) * major_axis, 0.0, sin(phi) * minor_axis)

func createArrows():
	xArrow = createArrow(Color.red)
	zArrow = createArrow(Color.blue)
	
	xArrow.name = "xArrow"
	zArrow.name = "zArrow"
	
	# Set to parent arrows to ignore planet scale inheritance
	var node = Node.new()
	node.name = "Orbit Arrows"
	node.add_child(xArrow)
	node.add_child(zArrow)
	
	self.add_child(node)
	
	# Set position
	var pos = Vector2(0.0, 0.0)
	pos.x = cos(0) * major_axis
	pos.y = sin(0) * minor_axis
	
	if major_axis > 0:
		pos.x += 1.0
	else:
		pos.x -= 1.0
	xArrow.translation = Vector3(pos.x, 0, pos.y)
	
	pos.x = cos(PI * 0.5) * major_axis
	pos.y = sin(PI * 0.5) * minor_axis
	if minor_axis > 0:
		pos.y += 1.0
	else:
		pos.y -= 1.0
	zArrow.translation = Vector3(pos.x, 0, pos.y)
	
func createArrow(color, scale = 0.2):
	var arrowMat = SpatialMaterial.new()
	arrowMat.albedo_color = color
	arrowMat.flags_unshaded = true
	
	var collisionShape = CollisionShape.new()
	collisionShape.shape = SphereShape.new()
	collisionShape.disabled = true
	
	var arrow = MeshInstance.new()
	arrow.mesh = SphereMesh.new()
	arrow.material_override = arrowMat
	
	arrow.set_scale(Vector3(scale, scale, scale))
	arrow.set_as_toplevel(true)
	arrow.visible = false
	
	var boundingArea = StaticBody.new()
	boundingArea.input_ray_pickable = false
	boundingArea.add_child(collisionShape)

	arrow.add_child(boundingArea)
	
	return arrow

func _randomizeName():
	var planetName = "X-"
	planetName += String(randi() % 1000)
	self.name = planetName

func orbit(dt):
	phi += orbitSpeed * dt
	position.x = cos(phi) * major_axis
	position.z = sin(phi) * minor_axis
	self.translation = position

func shouldPlanetOrbit(state):
	shouldOrbit = state
	pass

onready var mdt = MeshDataTool.new()
onready var sf = SurfaceTool.new()
func updateOrbitLines():
	createOribitLines(vertexCount)
	
	pass

func makeOrbitArrowVisible(isVisible):
	xArrow.visible = isVisible
	xArrow.get_child(0).input_ray_pickable = isVisible
	xArrow.get_child(0).get_child(0).disabled = !isVisible
	
	zArrow.visible = isVisible
	zArrow.get_child(0).input_ray_pickable = isVisible
	zArrow.get_child(0).get_child(0).disabled = !isVisible
	
func createOribitLines(vertexCount):
	sf = SurfaceTool.new()
	sf.begin(Mesh.PRIMITIVE_LINE_LOOP)
	
	var angle = 0
	var rad = ((2*PI) / vertexCount)
	var vPos = Vector3(0, 0, 0)
	for i in vertexCount:
		vPos.x = cos(angle) * major_axis
		vPos.z = sin(angle) * minor_axis

		sf.add_vertex(vPos)
		angle += rad
	
	
	if !orbitMesh:
		orbitMesh = MeshInstance.new()
		orbitMesh.mesh = sf.commit()
		
		var mat = SpatialMaterial.new()
		mat.albedo_color = Color.white
		mat.albedo_color.a = 0.1
		mat.flags_transparent = true
		mat.flags_unshaded = true
		orbitMesh.material_override = mat
		
		var node = Node.new()
		node.name = "orbitMeshNode"
		node.add_child(orbitMesh)
		self.add_child(node)
	else:
		orbitMesh.mesh.surface_remove(0)
		sf.commit(orbitMesh.mesh)

func rotatePlanet(relative):
	self.rotate_y(relative[0] * 0.05)
	pass

func _process(dt):
	if shouldOrbit:
		self.rotate_y(PI * axisRotateSpeed * dt)
		self.orbit(dt)
	pass

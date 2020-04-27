extends Spatial

var phi = 0.0
var orbitSpeed = randf() / 10
var axisRotateSpeed = 0.1

var minor_axis = 10
var major_axis = 10
var position
var nameLabel
var gotCamera = false
var offset
var cameraHolder
var camera
var unPos

var orbitMesh
var vertexCount = 20

export(bool) var isOrbiting = true


func _ready():
	_randomizeName()
	cameraHolder = get_tree().current_scene.get_node("CameraHolderMaster")
	
	position = Vector3(cos(phi) * major_axis, 0.0, sin(phi) * minor_axis)
	_createOribitLines(vertexCount)	
#	nameLabel = Label.new()
#	nameLabel.text = self.get_name()
#	offset = Vector2(nameLabel.get_size().x/2, 0)
#	self.add_child(nameLabel)
#	self.translation = Vector3(distanceFromSun.x, 0.0, distanceFromSun.y);

func _randomizeName():
	var planetName = "X-"
	planetName += String(randi() % 1000)
	self.name = planetName

func orbit(dt):
	phi += orbitSpeed * dt
	position.x = cos(phi) * major_axis
	position.z = sin(phi) * minor_axis
	self.translation = position


onready var mdt = MeshDataTool.new()
onready var sf = SurfaceTool.new()
func updateOrbitLines():
	_createOribitLines(vertexCount)
	
	pass

func _createOribitLines(vertexCount):
	sf = SurfaceTool.new()
	sf.begin(Mesh.PRIMITIVE_LINE_LOOP)
	
	var angle = 0
	var rad = ((2*PI) / vertexCount)
	var vPos = Vector3(0, 0, 0)
	for i in vertexCount:
		angle += rad
		vPos.x = cos(angle) * major_axis
		vPos.z = sin(angle) * minor_axis
		sf.add_vertex(vPos)
		
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
		node.add_child(orbitMesh)
		self.add_child(node)
	else:
		orbitMesh.mesh.surface_remove(0)
		sf.commit(orbitMesh.mesh)
	
func _process(dt):
	if isOrbiting:
		self.rotate_y(PI * axisRotateSpeed * dt)
		self.orbit(dt)
#	if cameraHolder:
	#   camera = cameraHolder.getCurrentCamera() #fett ooptimerat, fixa
	#	unPos = camera.unproject_position(self.global_transform.origin)
	#	if camera.global_transform.origin.dot(self.global_transform.origin) > 0:
	#		nameLabel.visible = false
	#	else:
	#		nameLabel.visible = true
	#
	#	nameLabel.set_position(unPos - offset)
	pass

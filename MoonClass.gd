class_name Moon extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var planetIOrbit
var moonMesh
var planetScale
var rotationSpeed
var moonNr
var offset
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _init(planet):

	self.name = String(planet.name) + String("-M-") + String(randi() % 20)
	planetIOrbit = planet
	var radius = planetIOrbit.get_child(0).get_child(0).mesh.radius

	moonMesh = MeshInstance.new()
	moonMesh.mesh = SphereMesh.new()
	self.add_child(moonMesh)

	planetScale = planetIOrbit.scale
	var moonSize = planetScale[0] * 0.05 * (randi() % 2) + 0.1
	var distanceFromSurface = randf() * radius + 0.1
	offset = Vector3((radius*15 + distanceFromSurface), 0.0, 0.0)
	moonMesh.global_transform.origin += offset
	self.scale *= moonSize
	rotationSpeed = (1/distanceFromSurface) * 0.05
	pass

func _process(delta):
	self.rotate_y(PI * delta * rotationSpeed)
	pass

func getMoon():
	return self
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

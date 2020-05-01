extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var planet
var moonMesh
var planetScale
var offset
var rotationSpeed
# Called when the node enters the scene tree for the first time.
func _ready():
	planet = get_parent()
	var radius = planet.get_child(0).get_child(0).mesh.radius
#	self.global_transform.origin = planet.global_transform.origin
	moonMesh = self.get_node("MoonMesh")
	planetScale = planet.scale
	var moonSize = planetScale[0] * 0.1 * randf() + 0.1
	var distanceFromSurface = randf() * radius + 0.1
	offset = Vector3((radius + distanceFromSurface), 0.0, 0.0)
	self.scale *= moonSize
	moonMesh.global_transform.origin += offset
	rotationSpeed = (1/distanceFromSurface) * 0.2
	pass # Replace with function body.

func _process(delta):
	self.rotate_y(PI * delta * rotationSpeed)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

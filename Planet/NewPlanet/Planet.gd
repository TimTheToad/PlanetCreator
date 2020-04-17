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
onready var cameraHolder = get_parent().get_parent().get_child(1)
var camera
var unPos

export(bool) var isOrbiting = true

func _ready():
	position = Vector3(cos(phi) * major_axis, 0.0, sin(phi) * minor_axis)
#	nameLabel = Label.new()
#	nameLabel.text = self.get_name()
#	offset = Vector2(nameLabel.get_size().x/2, 0)
#	self.add_child(nameLabel)
#	self.translation = Vector3(distanceFromSun.x, 0.0, distanceFromSun.y);

func orbit(dt):
	phi += orbitSpeed * dt
	position.x = cos(phi) * major_axis
	position.z = sin(phi) * minor_axis
	self.translation = position


func _process(dt):
	if isOrbiting:
		self.rotate_y(PI * axisRotateSpeed * dt)
		self.orbit(dt)
#	camera = cameraHolder.getCurrentCamera() #fett ooptimerat, fixa
#	unPos = camera.unproject_position(self.global_transform.origin)
#	if camera.global_transform.origin.dot(self.global_transform.origin) > 0:
#		nameLabel.visible = false
#	else:
#		nameLabel.visible = true
#
#	nameLabel.set_position(unPos - offset)
	pass

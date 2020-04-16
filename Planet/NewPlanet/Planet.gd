extends Spatial

var phi = 0.0
var orbitSpeed = randf()
var axisRotateSpeed = 0.1

var minor_axis
var major_axis
var position

func _ready():
	position = Vector3(cos(phi) * major_axis, 0.0, sin(phi) * minor_axis)
#	self.translation = Vector3(distanceFromSun.x, 0.0, distanceFromSun.y);

func orbit(dt):
	phi += orbitSpeed * dt
	
	position.x = cos(phi) * major_axis
	position.z = sin(phi) * minor_axis
	self.translation = position


func _process(dt):
	self.rotate_y(PI * axisRotateSpeed * dt)
	self.orbit(dt)
	pass

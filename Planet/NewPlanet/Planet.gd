extends Spatial

export(Vector2) var distanceFromSun
export(float) var rotationSpeed = PI * 0.001

func _ready():
	self.translation = Vector3(distanceFromSun.x, 0.0, distanceFromSun.y);

func orbit(dt):
	self.rotate_y(rotationSpeed * dt)

func _process(dt):
	#	self.orbit(dt)
	pass

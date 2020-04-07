extends Viewport


onready var camera = self.get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	_rotateCamera(PI * 0.25 * delta, Vector3(0, 1, 0))
	pass


func _rotateCamera(speed, vector):
	var pos = camera.translation
#	camera.global_rotate(vector, speed)

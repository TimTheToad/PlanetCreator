extends Spatial


var target
var secondCamera
var firstCamera
var currentCamera
# Called when the node enters the scene tree for the first time.

func _ready():
	firstCamera = self.get_node("CameraHolderY/ComeraHolderX/Camera")
	secondCamera = self.get_node("TopViewCamera")
	currentCamera = getCurrentCamera()
	pass

func setTarget(target):
	self.target = target

func _process(delta):
	
	if target and firstCamera.is_current():
		self.global_transform.origin = target.global_transform.origin
	
	pass

func _input(event):
	
	if event is InputEventKey:
		if event.is_action_pressed("ui_up") and !event.echo:
			secondCamera.make_current()
#			zoomSpeed = 1.5
			currentCamera = secondCamera
		if event.is_action_pressed("ui_down") and !event.echo:
			firstCamera.make_current()
#			zoomSpeed = 0.1
			currentCamera = self
	pass

func getCurrentCamera():
	if firstCamera.is_current():
		return firstCamera
	elif secondCamera.is_current():
		return secondCamera
	pass

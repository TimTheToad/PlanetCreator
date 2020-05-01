extends Spatial

var target
var secondCamera
var direction
var firstCamera
var currentCamera
var cameraHolderX

var zoomSpeed = 0.1

var cameraHolderY
var cameraNewRotation
# Called when the node enters the scene tree for the first time.

func _ready():
	var cameraOffset = Vector3(5, 0, 0)
	
	cameraHolderY = self.get_node("CameraHolderY")
	cameraHolderX = self.get_node("CameraHolderY/ComeraHolderX")
	firstCamera = self.get_node("CameraHolderY/ComeraHolderX/Camera")
	secondCamera = self.get_node("TopViewCamera")
	
	firstCamera.translate(cameraOffset)
	currentCamera = getCurrentCamera()
	updateLookAt()
	
	pass

func setTarget(target):
	self.target = target

func _process(delta):
	
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		if firstCamera.is_current():

			if cameraHolderX.rotation.x < deg2rad(80):
				cameraHolderX.rotate_x(cameraNewRotation[1] * 0.01)
			else:
				cameraHolderX.rotation.x = deg2rad(79)

			if cameraHolderX.rotation.x > -deg2rad(80):
				cameraHolderX.rotate_x(cameraNewRotation[1] * 0.01)
			else:
				cameraHolderX.rotation.x = -deg2rad(79)

			cameraHolderY.rotate_y(cameraNewRotation[0] * 0.01)
			cameraNewRotation = Vector2(0.0, 0.0)
		elif secondCamera.is_current():
			self.translate(Vector3(cameraNewRotation[0] * 0.1, 0.0, cameraNewRotation[1] * 0.1))
			cameraNewRotation = Vector2(0.0, 0.0)

	updateLookAt()
	
	if target and firstCamera.is_current():
		self.global_transform.origin = target.global_transform.origin
	
	pass

func _input(event):
	
	if event is InputEventKey:
		if event.is_action_pressed("ui_up") and !event.echo:
			secondCamera.make_current()
			zoomSpeed = 0.9
			currentCamera = secondCamera
			
			# Temp solution
			get_tree().current_scene.get_node("Control/Blueprint Editor").visible = false
			
		if event.is_action_pressed("ui_down") and !event.echo:
			firstCamera.make_current()
			zoomSpeed = 0.1
			currentCamera = firstCamera
			
			# Temp solution
			get_tree().current_scene.get_node("Control/Blueprint Editor").visible = true
			
	if event is InputEventMouseMotion:
		cameraNewRotation = event.get_relative()
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			if (currentCamera == firstCamera or secondCamera.translation.y > 2.0):
				currentCamera.translation = currentCamera.translation + direction * zoomSpeed
		if event.button_index == BUTTON_WHEEL_DOWN:
			if (currentCamera == firstCamera or secondCamera.translation.y < 40.0):
				currentCamera.translation = currentCamera.translation - direction * zoomSpeed

				
			
	pass
	
func updateLookAt():
	direction = -currentCamera.transform.origin.normalized()
	if firstCamera.is_current():
		currentCamera.look_at(self.transform.origin, Vector3(0.0, 1.0, 0.0))
	pass

func GetDirection():
	return direction

func getCurrentCamera():
	if firstCamera.is_current():
		return firstCamera
	elif secondCamera.is_current():
		return secondCamera
	pass

extends Spatial

var target = null
var secondCamera
var direction
var firstCamera
var currentCamera
var cameraHolderX

var zoomSpeed = 0.1

# for the free moving camera (w,a,s,d)
var thirdCamera
var moveSpeed = 1.5
var freecamHolder

var cameraHolderY
var cameraNewRotation

onready var PlanetRadialGUI = preload("res://GUI/PlanetRadialGUI/PlanetRadialControl.tscn")
var planetRadialInstance = null
onready var sunInstance = get_tree().current_scene.get_node("Sun")

func _ready():
	var cameraOffset = Vector3(5, 0, 0)
	
	cameraHolderY = self.get_node("CameraHolderY")
	cameraHolderX = self.get_node("CameraHolderY/ComeraHolderX")
	firstCamera = self.get_node("CameraHolderY/ComeraHolderX/Camera")
	secondCamera = self.get_node("TopViewCamera")
	freecamHolder = self.get_node("FreecamHolder")
	thirdCamera = self.get_node("FreecamHolder/Freecam")
	
	firstCamera.translate(cameraOffset)
	currentCamera = getCurrentCamera()
	updateLookAt()
	
	pass

func setTarget(target):
	self.target = target

func _process(delta):
	if thirdCamera.is_current():
		var movement := Vector3()
		if Input.is_action_pressed("move_forward"):
			movement -= thirdCamera.global_transform.basis.z 
		elif Input.is_action_pressed("move_back"):
			movement += thirdCamera.global_transform.basis.z 
		else:
			movement = Vector3(0,0,0)
			
		if Input.is_action_pressed("move_right"):
			movement += thirdCamera.global_transform.basis.x
		elif Input.is_action_pressed("move_left"):
			movement -= thirdCamera.global_transform.basis.x
		else:
			movement += Vector3(0,0,0)
		# normalized so if both forward and left is pressed it won't double the speed
		movement = movement.normalized()
		var speed = moveSpeed
		if Input.is_action_pressed("speed_boost"):
			speed = moveSpeed * 2
			
		self.translation += movement * speed * delta
	
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
		elif thirdCamera.is_current():
			if freecamHolder.rotation.x < deg2rad(80):
				freecamHolder.rotate_x(cameraNewRotation[1] * 0.01)
			else:
				freecamHolder.rotation.x = deg2rad(79)

			if freecamHolder.rotation.x > -deg2rad(80):
				freecamHolder.rotate_x(cameraNewRotation[1] * 0.01)
			else:
				freecamHolder.rotation.x = -deg2rad(79)

			self.rotate_y(cameraNewRotation[0] * 0.01)
			cameraNewRotation = Vector2(0.0, 0.0)
#	if InputEventMouseMotion:
#		if thirdCamera.is_current():
#
#			freecamHolder.rotate_x(-cameraNewRotation[1] * 0.01)
#
#			self.rotate_y(cameraNewRotation[0] * 0.01)
#			cameraNewRotation = Vector2(0.0, 0.0)
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
			
			
			if planetRadialInstance:
				planetRadialInstance.queue_free()
				planetRadialInstance = null
			
			# Temp solution
#			get_tree().current_scene.get_node("Control/Blueprint Editor").visible = false
			
		if event.is_action_pressed("ui_down") and !event.echo:
			firstCamera.make_current()
			zoomSpeed = 0.1
			currentCamera = firstCamera
			
						
			# Temp solution
#			get_tree().current_scene.get_node("Control/Blueprint Editor").visible = true
			
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
	


func GoToSun():
	currentCamera = self.firstCamera
	currentCamera.make_current()
	self.global_transform.origin = sunInstance.global_transform.origin
	self.target = sunInstance
	self.updateLookAt()

	if planetRadialInstance:
		planetRadialInstance.queue_free()
		planetRadialInstance = null

func GoToPlanet(planetInstance):
	currentCamera = self.firstCamera
	currentCamera.make_current()
	self.global_transform.origin = planetInstance.global_transform.origin
	self.target = planetInstance
	self.updateLookAt()

	# Add radial planet GUI
	if planetRadialInstance:
		planetRadialInstance.queue_free()

	# UYpdate blueprint editor
	var bpEditor = get_tree().current_scene.get_node("Control/Blueprint Editor")
	if bpEditor.visible:
		bpEditor.showPlanetBlueprint(planetInstance)
	
	var screenCoords = get_viewport().get_camera().unproject_position(planetInstance.translation)

	planetRadialInstance = PlanetRadialGUI.instance()
	planetRadialInstance.init(screenCoords, 128)
	planetInstance.add_child(planetRadialInstance)

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
	elif thirdCamera.is_current():
		return thirdCamera
	pass


func _on_TopViewButton_pressed():
	secondCamera.make_current()
	currentCamera = secondCamera
	updateLookAt()
	
	if planetRadialInstance:
		planetRadialInstance.queue_free()
		planetRadialInstance = null
	pass # Replace with function body.


func _on_OrbitalViewButton_pressed():
	firstCamera.make_current()
	currentCamera = firstCamera
	updateLookAt()
	pass # Replace with function body.


func _on_FreeCamViewButton_pressed():
	thirdCamera.make_current()
	updateLookAt()
	pass # Replace with function body.

extends Node

onready var blueprintEditor = get_parent().get_node("Control/Blueprint Editor")

var ray

var cameraHolder
var selected
var xArr
var zArr
var prevSelected
var camera
var rayOrigin
# Called when the node enters the scene tree for the first time.
func _ready():
	# Retrive camera
	cameraHolder = get_tree().current_scene.get_node("OrbitalCamera")

	if !cameraHolder:
		print("Failed to retrive cameraHolder for \"PlanetMover.gd\" on node: ", self.name)
	pass # Replace with function body.

func getZValue(arrow):
	return camera.global_transform.origin.distance_to(arrow)
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			# Get essential data for raycast
			var viewport = get_viewport()
			var mousePos = viewport.get_mouse_position()
			camera = cameraHolder.getCurrentCamera()
			# Project ray
			rayOrigin = camera.project_ray_origin(mousePos)
			var rayDir = camera.project_ray_normal(mousePos)
			var rayDist = 1000

			var from = rayOrigin
			var to = rayOrigin + rayDir * rayDist
			var spaceState = viewport.get_world().get_direct_space_state()
			var hit = spaceState.intersect_ray(from, to)
			if hit.size() != 0:
				# collider will be the node you hit
				selected = hit.collider.get_parent()
				
				if selected.name == "xArrow":
					xArr = selected
					selected = null
				elif selected.name == "zArrow":
					zArr = selected
					selected = null
					
				# if planet is selected
				else:
					if prevSelected:
						prevSelected.makeOrbitArrowVisible(false)
						prevSelected.highlight(false)
					selected.makeOrbitArrowVisible(true)
					selected.highlight(true)
					
#					if camera.name != "TopViewCamera":
#						blueprintEditor.showPlanetBlueprint(selected)

		if event.button_index == BUTTON_LEFT and !event.is_pressed():
			if selected:
				prevSelected = selected #saves the previously selected planet so we may "destroy" the arrows upon deselected
				selected = null
			if xArr:
				xArr = null
			if zArr:
				zArr = null
				print("Released planet")
		
		if event.button_index == BUTTON_LEFT and event.is_pressed() and event.doubleclick:
			var viewport = get_viewport()
			var mousePos = viewport.get_mouse_position()
			camera = cameraHolder.getCurrentCamera()
			# Project ray
			rayOrigin = camera.project_ray_origin(mousePos)
			var rayDir = camera.project_ray_normal(mousePos)
			var rayDist = 1000

			var from = rayOrigin
			var to = rayOrigin + rayDir * rayDist
			var spaceState = viewport.get_world().get_direct_space_state()
			var hit = spaceState.intersect_ray(from, to)
			if hit.size() != 0:
				# collider will be the node you hit
				var planetInstance = hit.collider.get_parent()
				#think this is correct way to only double click planets
				if  planetInstance.get_parent().name == "Planets":
					cameraHolder.firstCamera.make_current()
					cameraHolder.global_transform.origin = planetInstance.global_transform.origin
					cameraHolder.target = planetInstance
					cameraHolder.updateLookAt()

	if xArr:
		if event is InputEventMouseMotion:
#			var relative = event.get_relative() * 0.1
			var distanceToObject = getZValue(xArr.global_transform.origin)
#			print(distanceToObject)
			var arrowPosition = camera.project_position(event.position, camera.global_transform.origin.y)
#			var arrowPosition = camera.project_position(event.position, distanceToObject) - Vector3(1.0, 0.0, 0.0)
			
			var planet = xArr.get_parent().get_parent()
			var offset = 0.0
			
			if planet.major_axis > 0.0:
				offset = -1.0
				if planet.major_axis < 1.0:
					offset = -planet.major_axis
			
			if planet.major_axis < 0.0:
				offset = 1.0
				if planet.major_axis > -1.0:
					offset = -planet.major_axis
			
			planet.major_axis = arrowPosition.x + offset
			
			arrowPosition.z = 0.0
			xArr.translation = arrowPosition

			planet.updateOrbitLines()
			
	elif zArr:
		if event is InputEventMouseMotion:
			var distanceToObject = getZValue(zArr.global_transform.origin)
			var arrowPosition = camera.project_position(event.position, camera.global_transform.origin.y)
			
			var planet = zArr.get_parent().get_parent()
			var offset = 0.0
			
			if planet.minor_axis > 0.0:
				offset = -1.0
				if planet.minor_axis < 1.0:
					offset = -planet.minor_axis
			
			if planet.minor_axis < 0.0:
				offset = 1.0
				if planet.minor_axis > -1.0:
					offset = -planet.minor_axis
			
			planet.minor_axis = arrowPosition.z + offset
			
			arrowPosition.x = 0.0
			zArr.translation = arrowPosition
			
			planet.updateOrbitLines()
		


extends Node

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
	cameraHolder = get_tree().current_scene.get_node("CameraHolderMaster")

	if !cameraHolder:
		print("Failed to retrive cameraHolder for \"PlanetMover.gd\" on node: ", self.name)
	pass # Replace with function body.

func getZValue(arrow):
	print(camera.global_transform.origin.distance_to(arrow))
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
					print("xArrow Hit")
				elif selected.name == "zArrow":
					zArr = selected
					selected = null
					print("zArrow Hit")
				else:
					print("Planet Hit")
					if prevSelected:
						prevSelected.makeOrbitArrowVisible(false)
					selected.makeOrbitArrowVisible(true)
			elif hit.size() == 0:
				print("missed")
				if prevSelected:
					prevSelected.makeOrbitArrowVisible(false)

		if event.button_index == BUTTON_LEFT and !event.is_pressed():
			if selected:
				prevSelected = selected #saves the previously selected planet so we may "destroy" the arrows upon deselected
				selected = null
			if xArr:
				xArr = null
			if zArr:
				zArr = null
				print("Released planet")

	if xArr:
		if event is InputEventMouseMotion:
#			var relative = event.get_relative() * 0.1
			var distanceToObject = getZValue(xArr.global_transform.origin)
#			print(distanceToObject)
			var arrowPosition = camera.project_position(event.position, camera.global_transform.origin.y) - Vector3(1.0, 0.0, 0.0)
#			var arrowPosition = camera.project_position(event.position, distanceToObject) - Vector3(1.0, 0.0, 0.0)
			xArr.get_parent().major_axis = arrowPosition.x
			xArr.get_parent().updateOrbitLines()
	elif zArr:
		if event is InputEventMouseMotion:
#			var relative = event.get_relative() * 0.1
			var distanceToObject = getZValue(zArr.global_transform.origin)
#			print(distanceToObject)
			var arrowPosition = camera.project_position(event.position, camera.global_transform.origin.y)  - Vector3(0.0, 0.0, 1.0)
#			var arrowPosition = camera.project_position(event.position, distanceToObject)  - Vector3(0.0, 0.0, 1.0)
			zArr.get_parent().minor_axis = arrowPosition.z
			zArr.get_parent().updateOrbitLines()

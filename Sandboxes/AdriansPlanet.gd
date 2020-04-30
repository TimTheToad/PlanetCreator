extends Spatial

onready var planets = get_node("Planets")
onready var cameraHolder = get_node("CameraHolderY")
onready var blueprintEditor = get_node("Blueprint Editor")

var selected

var ctrlHeld = false

func _input(event):

	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			# Get essential data for raycast
			var camera = cameraHolder.getCurrentCamera()
			var viewport = get_viewport()
			var mousePos = viewport.get_mouse_position()
			
			# Project ray
			var rayOrigin = camera.project_ray_origin(mousePos)
			var rayDir = camera.project_ray_normal(mousePos)
			var rayDist = 1000
			
			var from = rayOrigin
			var to = rayOrigin + rayDir * rayDist
			var spaceState = viewport.get_world().get_direct_space_state()
			var hit = spaceState.intersect_ray(from, to)
			if hit.size() != 0:
				# collider will be the node you hit
				selected = hit.collider.get_parent()
				blueprintEditor.showPlanetBlueprint(selected)
				
	if event is InputEventKey:
		if event.is_action_pressed("ui_copy"):
			print("Copy")
		
		if event.is_action_pressed("ui_paste"):
			print("Paste")
		


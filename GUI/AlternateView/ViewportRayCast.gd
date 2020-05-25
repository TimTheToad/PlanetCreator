extends Node
signal selectPlanet(selected)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var camera
var rayOrigin
var selected
var isSelected = false
var alternateViewRoot
var cameraHolder
var planetsInScene
# Called when the node enters the scene tree for the first time.
func _ready():
	planetsInScene = get_tree().current_scene.get_node("Planets")
	cameraHolder = get_tree().current_scene.get_node("OrbitalCamera")
	alternateViewRoot = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()
	self.connect("selectPlanet", alternateViewRoot, "_selectPlanetName")
	get_parent().connect("gui_input", self, "_handleGuiEvent")
	pass # Replace with function body.

func _handleGuiEvent(event):	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			# Get essential data for raycast
			var viewport = self
			var mousePos = viewport.get_mouse_position()
#			print(mousePos)
#			print(event.position)
			# Project ray
			camera = self.get_node("camera")
			rayOrigin = camera.project_ray_origin(event.position)
			var rayDir = camera.project_ray_normal(event.position)
#			print(get_child(0).global_transform.origin)
#			print(rayDir)
#			print(rayOrigin)
			var rayDist = 1000

			var from = rayOrigin
			var to = rayOrigin + rayDir * rayDist
			var spaceState = viewport.get_world().get_direct_space_state()
			var hit = spaceState.intersect_ray(from, to)
			if hit.size() != 0:
				# collider will be the node you hit
				selected = hit.collider.get_parent()
#				print(selected)
				emit_signal("selectPlanet", selected)
#				print(selected)
		if event.button_index == BUTTON_LEFT and event.is_pressed() and event.doubleclick:
						# Get essential data for raycast
			var viewport = self
			var mousePos = viewport.get_mouse_position()
#			print(mousePos)
#			print(event.position)
			# Project ray
			camera = self.get_node("camera")
			rayOrigin = camera.project_ray_origin(event.position)
			var rayDir = camera.project_ray_normal(event.position)
#			print(get_child(0).global_transform.origin)
#			print(rayDir)
#			print(rayOrigin)
			var rayDist = 1000

			var from = rayOrigin
			var to = rayOrigin + rayDir * rayDist
			var spaceState = viewport.get_world().get_direct_space_state()
			var hit = spaceState.intersect_ray(from, to)
			if hit.size() != 0:
				# collider will be the node you hit
				selected = hit.collider.get_parent()
#				planetsInScene = get_tree().current_scene.get_node("Planets")
#				print(selected)
				for i in range(planetsInScene.get_child_count()):
					print("Selected: " + selected.name)
					print("PlanetInScene: " + planetsInScene.get_child(i).name)
					if planetsInScene.get_child(i).name == selected.name:
						cameraHolder.GoToPlanet(planetsInScene.get_child(i))
						continue
						
#				print(selected)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

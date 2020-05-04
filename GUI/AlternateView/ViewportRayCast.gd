extends Node
signal updateName(selected)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var camera
var rayOrigin
var selected
var isSelected = false
var alternateViewRoot
# Called when the node enters the scene tree for the first time.
func _ready():
	
	alternateViewRoot = get_parent().get_parent().get_parent().get_parent()
	self.connect("updateName", alternateViewRoot, "_updatePlanetName")
	get_parent().connect("gui_input", self, "_handleGuiEvent")
	pass # Replace with function body.

func _handleGuiEvent(event):	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
#			print("snopp")
			# Get essential data for raycast
			var viewport = self
			var mousePos = viewport.get_mouse_position()
			print(mousePos)
			print(event.position)
			# Project ray
			camera = self.get_node("camera")
			rayOrigin = camera.project_ray_origin(event.position)
			var rayDir = camera.project_ray_normal(event.position)
#			print(get_child(0).global_transform.origin)
#			print(rayDir)
			print(rayOrigin)
			var rayDist = 1000

			var from = rayOrigin
			var to = rayOrigin + rayDir * rayDist
			var spaceState = viewport.get_world().get_direct_space_state()
			var hit = spaceState.intersect_ray(from, to)
			if hit.size() != 0:
				# collider will be the node you hit
				selected = hit.collider.get_parent()
				print(selected)
				emit_signal("updateName", selected)
#				print(selected)

	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

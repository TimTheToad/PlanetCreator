extends ColorRect

onready var camera = get_node("ViewportContainer/Viewport/Camera")
onready var planet = get_node("ViewportContainer/Viewport/NewPlanet")
onready var viewport = get_node("ViewportContainer/Viewport")

func _ready():
	viewport.render_target_update_mode = viewport.UPDATE_ONCE


func _input(event):
   # Mouse in viewport coordinates
   if event is InputEventMouseMotion:
	   self.rect_global_position = event.position
	
func changeBlueprint(blueprint):
	planet.blueprint = blueprint
	planet.applyBlueprint()
#	viewport.render_target_update_mode = viewport.UPDATE_ONCE

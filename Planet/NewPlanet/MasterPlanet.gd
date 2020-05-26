extends Spatial

onready var planetScene = preload("res://Planet/NewPlanet/NewPlanet.tscn")
onready var alternateView = preload("res://GUI/AlternateView/AlternateViewRoot.tscn")
onready var alternateInstance = alternateView.instance()
const PLANET_COUNT = 5
var modifiedPlanets = []

var minDist = 15
var randDist = 10
var totalDist = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	

	randomize()
	for i in range(PLANET_COUNT):
		var instance = planetScene.instance()
		
		totalDist = minDist + randDist * ((randf() -0.5) * 2)
		
		instance.minor_axis = totalDist
		instance.major_axis = totalDist + 2 * ((randf() - 0.5) * 2)
		instance.phi = PI * 2.0 * randf()
		var s = 0.25 + randf()
		instance.scale = Vector3(s,s,s)
		instance.randomizeName()
		self.add_child(instance)
		instance.shouldPlanetOrbit(true)
		instance.createOribitLines(instance.vertexCount)

	alternateInstance.connect("sorted", self, "updateAlternateView")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt):
#	self.rotate_y(PI * 0.01 * dt)
	pass
	




func _on_Pause_toggled(button_pressed):
	
	for child in self.get_children():
		child.shouldOrbit = !button_pressed
	
	pass # Replace with function body.

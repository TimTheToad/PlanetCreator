extends Spatial

onready var planetScene = preload("res://Planet/NewPlanet/NewPlanet.tscn")
onready var alternateView = preload("res://GUI/AlternateView/AlternateViewRoot.tscn")
onready var alternateInstance = alternateView.instance()
const PLANET_COUNT = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var minDist = 30
	var randDist = 20
	randomize()
	for i in range(PLANET_COUNT):
		var instance = planetScene.instance()
		instance.minor_axis = minDist + randDist * ((randf() -0.5) * 2)
		instance.major_axis = instance.minor_axis + 2 * ((randf() - 0.5) * 2)
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
	



extends Spatial

onready var planetScene = preload("res://Planet/NewPlanet/NewPlanet.tscn")
const PLANET_COUNT = 6
# Called when the node enters the scene tree for the first time.
func _ready():
	
	for i in range(PLANET_COUNT):
		var instance = planetScene.instance()
		instance.distanceFromSun = Vector2(((randf() - 0.5) * 2.0) * 50 + 25, ((randf() - 0.5) * 2.0) * 50 + 25)
		self.add_child(instance)
		
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt):
	self.rotate_y(PI * 0.01 * dt)
	pass

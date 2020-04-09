extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int) var sunOffset = 15
onready var sunHolder = self.get_parent()
onready var light = self.get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():

	self.translate(Vector3(sunOffset, 0, 0))
	
	light.look_at(sunHolder.get_translation(), Vector3(0.0, 1.0, 0.0))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	sunHolder.rotate_y(delta * 0.01)
	light.look_at(sunHolder.get_translation(), Vector3(0.0, 1.0, 0.0))
	pass

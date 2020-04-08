extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


onready var planet = preload("res://Planet/Planet Mesh.tscn")
onready var planetInstance = planet.instance()
var cameraOffset
var cameraNewPosition
var mouseIsMoving = false
var canMove = false

# Called when the node enters the scene tree for the first time.
func _ready():
	cameraOffset = 10

	var targetPosition = planetInstance.get_translation()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_mouse_button_pressed(BUTTON_MIDDLE):
			canMove = true
			print("middle butrton pressed")
			print(cameraNewPosition)
			cameraNewPosition = Vector2(0.0, 0.0)
			#self.look_at(targetPosition)
	if canMove:
		var hi
	pass


func _input(event):
	
	if event is InputEventMouseMotion:
		cameraNewPosition = event.get_relative()
	pass

func MoveAroundPlanet():
	pass

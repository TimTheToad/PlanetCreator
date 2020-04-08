extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


onready var planet = preload("res://Planet/Planet Mesh.tscn")
onready var planetInstance = planet.instance()
export(Vector3) var cameraOffset
var cameraNewRotation
var direction
var mouseIsMoving = false
var cameraHolder
var canMove = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	cameraOffset = Vector3(5, 0, 0)
	self.translate(cameraOffset)
	cameraHolder = self.get_parent()
	direction = cameraHolder.get_translation() - self.get_translation()
	self.look_at(cameraHolder.get_translation(), Vector3(0.0, 1.0, 0.0))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_mouse_button_pressed(BUTTON_MIDDLE):
			canMove = true
			print("middle butrton pressed")
			cameraHolder.rotate_x(cameraNewRotation[1] * 0.01)
			cameraHolder.rotate_y(cameraNewRotation[0] * 0.01)
			cameraNewRotation = Vector2(0.0, 0.0)
			
	direction = cameraHolder.get_translation() - self.get_translation()
	self.look_at(cameraHolder.get_translation(), Vector3(0.0, 1.0, 0.0))
	pass


func _input(event):
	
	if event is InputEventMouseMotion:
		cameraNewRotation = event.get_relative()
		
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			self.set_translation(self.get_translation() + direction * 0.01)
			print(self.get_translation())
			
		if event.button_index == BUTTON_WHEEL_DOWN:
			self.set_translation(self.get_translation() - direction * 0.01)
			print(self.get_translation())
	pass

func MoveAroundPlanet():
	pass

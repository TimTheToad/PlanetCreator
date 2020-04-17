extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var radius = 50
var points
var buttons = []
onready var buttonHolder = get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	points = 360 / buttonHolder.get_child_count()
	buttonHolder.visible = false
	
	for i in range(buttonHolder.get_child_count()):
		buttons.append(buttonHolder.get_child(i))
	
	pass # Replace with function body.
	
func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("Radial"):
			buttonHolder.visible = true
			print(event.position)
			PositionButtonsInRadial(event.position)
	if event is InputEventKey:
		if event.is_action_pressed("ui_cancel"):
			buttonHolder.visible = false
	pass

func PositionButtonsInRadial(mousePos):
	var iterator = 0
	buttonHolder.rect_global_position = mousePos
	for button in buttons:
		var offsetXY = Vector2(radius * cos(deg2rad(points) * iterator), radius * sin(deg2rad(points) * iterator))
		button.rect_position = Vector2(offsetXY.x + (radius * cos(deg2rad(points) * iterator)), offsetXY.y + (radius * sin(deg2rad(points) * iterator)))
		iterator += 1
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

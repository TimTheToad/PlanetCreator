extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var planets = get_parent().get_parent().get_child(0)
onready var planetContainer = get_node("PanelContainer/VBoxContainer")
onready var cameraHolder = get_parent().get_parent().get_child(1)
onready var camera = cameraHolder.get_child(0).get_child(0).get_child(0)
#onready var cameraInstance = camera.instance()
var nrOfPlanets
# Called when the node enters the scene tree for the first time.
func _ready():
	nrOfPlanets = planets.get_child_count()
	for i in range(nrOfPlanets):
		var button = Button.new()
		button.text = planets.get_child(i).get_name()
		button.connect("pressed", self, "_GoToPlanet", [button.text])
		planetContainer.add_child(button)
		
	self.visible = true
	pass # Replace with function body.

func _GoToPlanet(name):
	print(name)
	var camera = cameraHolder.get_child(0).get_child(0).get_child(0)
	var planetInstance = planets.get_node(name)
	cameraHolder.target = planetInstance
	camera.make_current()


		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

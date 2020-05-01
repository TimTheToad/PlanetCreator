extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var planets = get_parent().get_parent().get_parent().get_child(0)
onready var planetContainer = get_node("PanelContainer/VBoxContainer")
var cameraHolder
var camera
#onready var cameraInstance = camera.instance()
var nrOfPlanets
# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	cameraHolder = get_parent().get_parent().get_parent().get_node("CameraHolderMaster")
	if cameraHolder:
		camera = cameraHolder.get_child(0).get_child(0).get_child(0)
		
		nrOfPlanets = planets.get_child_count()
		for i in range(nrOfPlanets):
			var button = Button.new()
			button.text = planets.get_child(i).get_name()
			button.connect("pressed", self, "_GoToPlanet", [button.text])
			planetContainer.add_child(button)
			
	pass # Replace with function body.

func _GoToPlanet(name):
	print(name)
	var planetInstance = planets.get_node(name)
	cameraHolder.firstCamera.make_current()
	cameraHolder.global_transform.origin = planetInstance.global_transform.origin
	cameraHolder.target = planetInstance
	cameraHolder.updateLookAt()


		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

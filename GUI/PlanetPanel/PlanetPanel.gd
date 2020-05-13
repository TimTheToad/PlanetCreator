extends WindowDialog

signal planetPanelSignal
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var planets = get_parent().get_parent().get_parent().get_child(0)
onready var planetContainer = get_node("PanelContainer/VBoxContainer")

onready var cameraHolder = get_tree().current_scene.get_node("OrbitalCamera")
var camera
#onready var cameraInstance = camera.instance()
var nrOfPlanets


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	self.connect("planetPanelSignal", self, "updatePanel")
#	cameraHolder = get_parent().get_parent().get_parent().get_node("OrbitalCamera")
	if cameraHolder:
		camera = cameraHolder.get_child(0).get_child(0).get_child(0)
		
		nrOfPlanets = planets.get_child_count()
		for i in range(nrOfPlanets):
			var button = Button.new()
			button.text = planets.get_child(i).get_name()
			button.connect("pressed", self, "_GoToPlanet", [button.text])
			planetContainer.add_child(button)
			
	pass # Replace with function body.

func updatePanel():
	nrOfPlanets = planets.get_child_count()
	for i in range(nrOfPlanets):
		planetContainer.get_child(i).queue_free()
		var button = Button.new()
		var planet = planets.get_child(i)
		button.text = planet.get_name()
		button.connect("pressed", cameraHolder, "GoToPlanet", [planet])
		planetContainer.add_child(button)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

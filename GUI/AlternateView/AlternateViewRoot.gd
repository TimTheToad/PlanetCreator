extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var hBoxContainer = get_node("HBoxContainer")
onready var window = self
onready var planetsInScene = get_parent().get_parent().get_parent().get_child(0)
onready var environment = get_parent().get_parent().get_parent().get_node("WorldEnvironment")
var planetsInView = []
var cameras = []
var nameLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	
	window.visible = false
	for i in range(planetsInScene.get_child_count()):
		var viewPortContainer = ViewportContainer.new()
		viewPortContainer.stretch = true
		viewPortContainer.set_h_size_flags(3) #Expand horizontal
		hBoxContainer.add_child(viewPortContainer)
		
		var viewPort = Viewport.new()
		viewPort.own_world = true
		var world = World.new()
		print(environment)
		var environmentDupe = environment.environment.duplicate()
		environmentDupe.ambient_light_color = Color.white
		world.environment = environmentDupe
		viewPort.world = world
		viewPortContainer.add_child(viewPort)
		nameLabel = Label.new()
		nameLabel.text = planetsInScene.get_child(i).get_name()
		var planet = planetsInScene.get_child(i).duplicate()

		planet.get_child(3).queue_free()
		planet.add_child(nameLabel)
		viewPort.add_child(planet)
		
		var camera = Camera.new()
		camera.set_orthogonal(3.0, 0.05, 15.0)
		camera.translate(Vector3(5.0, 0.0, 0.0))
		camera.look_at(planet.translation, Vector3(0.0, 1.0, 0.0))
		viewPort.add_child(camera)
		cameras.append(camera)
#		var omniLight = OmniLight.new()
		planetsInView.append(viewPort.get_child(0))
#		viewPort.add_child(omniLight)
#		omniLight.translate(Vector3(2.0, 1.0, 0.0))

	
	pass # Replace with function body.

func _process(delta):
	var iter = 0
	for camera in cameras:
		camera.look_at(planetsInView[iter].translation, Vector3(0.0, 1.0, 0.0))
		iter += 1
	pass

func getPlanetsInScene():
	return 	get_parent().get_child(0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

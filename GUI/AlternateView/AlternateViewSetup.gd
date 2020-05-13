extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var panelStyleNotSelected = load("res://GUI/AlternateView/AlternatePanelStyleNotSelected.tres")
onready var panelStyleSelected = load("res://GUI/AlternateView/AlternatePanelStyleSelected.tres")
onready var hBoxContainer = get_node("ScrollContainer/HBoxContainer")
onready var environment = get_tree().current_scene.get_node("WorldEnvironment")
onready var rayScript = load("res://GUI/AlternateView/ViewportRayCast.gd")
onready var planetsInScene = get_tree().current_scene.get_node("Planets")
var panelContainers = []
var viewPorts = []
var cameras = []
var planetsInView = []
var nameDic = {}
var sizeDic = {}
var nameLabel
var sizeLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func getNameDic():
	return nameDic
	pass

func getSizeDic():
	return sizeDic
	
func getViewPorts():
	return viewPorts
	
func getCameras():
	return cameras
	
func getPlanetsInView():
	return cameras
	
func getPanelContainers():
	return planetsInView

func intiAlternateView():
	for i in range(planetsInScene.get_child_count()):
		var panel = createPanel()
		var vBox = createVBoxContainer()
		var vpContainer = createViewPortContainer()
		var viewPort = createViewPort(i)
		hBoxContainer.add_child(panel)
		panel.add_child(vBox)
		vBox.add_child(vpContainer)
		vpContainer.add_child(viewPort)
		vBox.add_child(nameLabel)
		vBox.add_child(sizeLabel)
	pass

func createViewPortContainer():
	var viewPortContainer = ViewportContainer.new()
	viewPortContainer.stretch = true
	viewPortContainer.set_h_size_flags(3) #Expand horizontal
	viewPortContainer.set_v_size_flags(3)
#		viewPortContainer.rect_min_size = Vector2(160,100)
	viewPortContainer.anchor_bottom = 1
	viewPortContainer.anchor_right = 1
	viewPortContainer.connect("mouse_entered", self, "_on_ViewPortContainer_mouse_entered", [viewPortContainer])
	viewPortContainer.connect("mouse_exited", self, "_on_ViewPortContainer_mouse_exited")
	return viewPortContainer
	pass

func createPanel():
	var panel = Panel.new()
	panel.set_h_size_flags(3)
	panel.set_v_size_flags(3)
	panel.rect_min_size = Vector2(150,0)
	panel.anchor_bottom = 1
	panel.anchor_right = 1
	panel.set('custom_styles/panel', panelStyleNotSelected)
	panelContainers.append(panel)
#	hBoxContainer.add_child(panel)
	return panel
	pass

func createViewPort(index):
	var viewPort = Viewport.new()
	viewPort.render_target_update_mode = Viewport.UPDATE_WHEN_VISIBLE
	viewPort.set_script(rayScript)
	viewPorts.append(viewPort)
#		viewPort.size = Vector2(100, 100)
	var world = World.new()
	var environmentDupe = environment.environment.duplicate()
	environmentDupe.ambient_light_color = Color.white
	environmentDupe.ambient_light_energy = 4
	world.environment = environmentDupe
	viewPort.world = world

	
	nameLabel = Label.new()
	nameLabel.text = "Name: " + planetsInScene.get_child(index).get_name()
	nameLabel.name = "nameLabel"
	var planet = planetsInScene.get_child(index).duplicate()
	planet.name = planetsInScene.get_child(index).get_name()
	nameDic[planet.name] = planet
	sizeDic[planet.scale[0]] = planet
	planet.get_node("OrbitMeshNode").queue_free()
	sizeLabel = Label.new()
	sizeLabel.text = "Radius: " + String(stepify(planet.scale[0] * 1000, 0.01)) + "Km"
	viewPort.add_child(planet)
	
	var camera = Camera.new()
	camera.name = "camera"
	camera.set_orthogonal(3.0, 0.05, 50.0)
	camera.translate(Vector3(5.0, 0.0, 0.0))
	camera.look_at(planet.translation, Vector3(0.0, 1.0, 0.0))
	viewPort.add_child(camera)
	cameras.append(camera)
	var omniLight = OmniLight.new()
	planetsInView.append(viewPort.get_child(0))
	viewPort.add_child(omniLight)
	omniLight.translate(Vector3(2.0, 0.0, 0.0))
	return viewPort
	pass

func createVBoxContainer():
	var vBoxContainer = VBoxContainer.new()
	vBoxContainer.margin_bottom = -10
	vBoxContainer.margin_right = -10
	vBoxContainer.margin_left = 10
	vBoxContainer.margin_top = 10
	vBoxContainer.anchor_bottom = 1
	vBoxContainer.anchor_right = 1
	vBoxContainer.set_h_size_flags(3)
	vBoxContainer.set_v_size_flags(3)
#		vBoxContainer.rect_min_size = Vector2(200,0)
#		vBoxContainer.set_script(sizeScript)
#	panel.add_child(vBoxContainer)
	return vBoxContainer
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends Control

var dirLayerIcons

var radius = 128

var FillButtonsScene = preload("res://GUI/PlanetRadialGUI/FillButtons.tscn")
var NoiseButtonsScene = preload("res://GUI/PlanetRadialGUI/NoiseButtons.tscn")

var backIcon = preload("res://Assets/Icons/back.png")

var currLayer
var currLayerEvent
var currLayerEventButtons
var parent


func init(position, radius = 128):
	self.radius = radius
	self.rect_position = position

func _ready():
	self.parent = get_parent()
	
	for child in self.get_children():
		child.visible = false
	
	self.get_node("StartButtons").visible = true
	var startButtons = self.get_node("StartButtons").get_children()
	var layerButtons = self.get_node("LayerButtons").get_children()
	var eventButtons = self.get_node("EventButtons").get_children()
	
	
	positionButtons(PI * 0.5, startButtons)
	positionButtons(PI * 0.5, layerButtons)
	positionButtons(PI * 0.5, eventButtons)

	
	# Connect internal back buttons 
	_connectJump(layerButtons[0], 0)
	_connectJump(eventButtons[0], 1)

	
	# Connect external back buttons 
	var cameraHolder = get_tree().current_scene.get_node("OrbitalCamera")
	startButtons[0].connect("pressed", cameraHolder, "GoToSun")
	startButtons[0].connect("pressed", self, "_showBlueprintEdtior", [false])
	
	# Connect jump to next stage of buttons
	_connectJump(startButtons[1], 1)
	startButtons[2].connect("toggled", self , "_showBlueprintEdtior")
	startButtons[3].connect("toggled", self, "_goToAlternateView")
	
	_connectAllJump(layerButtons.slice(1, layerButtons.size()), 2)
	
	# Connect layer options
	layerButtons[1].connect("pressed", self, "_connectGetLayer", [layerButtons[1].name])
	layerButtons[2].connect("pressed", self, "_connectGetLayer", [layerButtons[2].name])
	layerButtons[3].connect("pressed", self, "_connectGetLayer", [layerButtons[3].name])
	
	# Connect eventLayer options
	eventButtons[1].connect("pressed", self, "_connectAddLayerEvent", [0])
	eventButtons[2].connect("pressed", self, "_connectAddLayerEvent", [1])
	eventButtons[5].connect("toggled", self, "_showMore")

func _showBlueprintEdtior(toggle):
	var bpEditor = get_tree().current_scene.get_node("Control/Blueprint Editor")
	bpEditor.visible = toggle
	if toggle:
		bpEditor.showPlanetBlueprint(parent)

func _goToAlternateView(toggle):
	var alternateView = get_tree().current_scene.get_child(4).get_child(2).get_child(2)
	alternateView.searchPlanet(parent.name)
	alternateView.visible = toggle
	alternateView.set_anchors_preset(Control.PRESET_CENTER, true);
	alternateView._set_size(Vector2(500,500))
	pass

func _removeCurrentEvent():
	currLayer.removeEvent(currLayerEvent)
	parent.applyBlueprint()
	_removeCurrentEventButtons()
	
func _removeCurrentEventButtons():
	currLayerEventButtons.visible = false
	currLayerEventButtons.queue_free()

func _showMore(toggle):
	self.get_node("EventButtons/More/Panel").visible = toggle;

func _connectAddLayerEvent(type):
	for child in self.get_children():
		child.visible = false
	
	var children
	match type:
		0:
			currLayerEvent = currLayer.addFill(Color.white)
			currLayerEventButtons =  FillButtonsScene.instance()
			
			# Add as child
			self.add_child(currLayerEventButtons)
			children = currLayerEventButtons.get_children()
			
				# Set up finish button signals
			children[2].connect("pressed", self, "_removeCurrentEventButtons")
			children[2].connect("pressed", self, "_goTo", [0])
			
			# Set up settings controls to event
			var colorPickerButton = currLayerEventButtons.get_node("Color")
			colorPickerButton.color = currLayerEvent.color
			colorPickerButton.connect("color_changed", currLayerEvent, "setColor")
		1:
			currLayerEvent = currLayer.addNoise(0.8, 5, Color.white)
			currLayerEventButtons = NoiseButtonsScene.instance()
			
			# Add as child
			self.add_child(currLayerEventButtons)
			children = currLayerEventButtons.get_children()
			
			# Set up finish button signals
			children[4].connect("pressed", self, "_removeCurrentEventButtons")
			children[4].connect("pressed", self, "_goTo", [0])
			
			# Set up settings controls to event
			var slider = currLayerEventButtons.get_node("Period/HBoxContainer/HSlider")
			slider.value = currLayerEvent.period
			slider.connect("value_changed", currLayerEvent, "setPeriod")
			
			slider = currLayerEventButtons.get_node("Octave/HBoxContainer/HSlider")
			slider.value = currLayerEvent.octave
			slider.connect("value_changed", currLayerEvent, "setOctave")
			
			var colorPickerButton = currLayerEventButtons.get_node("Color")
			colorPickerButton.color = currLayerEvent.color
			colorPickerButton.connect("color_changed", currLayerEvent, "setColor")
			
	positionButtons(PI * 0.5, children)
	_connectJump(children[0], 2)
	children[0].connect("pressed", self, "_removeCurrentEvent")
			
	parent.applyBlueprint()
	
func _connectGetLayer(layer):
	currLayer = parent.blueprint.getLayer(layer)

func _connectAllJump(buttons, index):
	for button in buttons:
		_connectJump(button, index)

func _connectJump(button, index):
	button.connect("pressed", self, "_goTo", [index])

func _goTo(index):
	for child in self.get_children():
		child.visible = false
	
	self.get_child(index).visible = true
	

func positionButtons(startAngle, buttons):
	var size = buttons.size()
	
	if size % 2 != 0:
		size += 1
	
	var index = 0
	var angle = (PI * 2 / size)
	for button in buttons:
		var x = cos(index * angle  - startAngle) * radius 
		var y = sin(index * angle  - startAngle) * radius
		button.rect_position = Vector2(x, y) - button.rect_size * 0.5
		index += 1


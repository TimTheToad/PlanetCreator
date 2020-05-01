extends WindowDialog

onready var LayerPanel = preload("res://GUI/BlueprintEditor/LayerPanel.tscn")
onready var container = get_node("Panel/VBoxContainer/ScrollContainer/HBoxContainer")
onready var blueprintNameLabel = get_node("Panel/VBoxContainer/MarginContainer2/HBoxContainer/VBoxContainer/Label")
onready var eventSettings = get_node("EventSettings")
onready var blueprintLibraryPanel = get_node("BlueprintLibrary")

var currentPlanet
var currentBlueprint

var selectedLayers = []
var selectedEvent = null

func showPlanetBlueprint(planet):
	
	selectedLayers.clear()
	selectedEvent = null
	eventSettings.visible = false
	currentPlanet = planet
	
	currentBlueprint = currentPlanet.blueprint
	blueprintNameLabel.set_text(currentBlueprint.title)
	
	var showCloudsButton = get_node("Panel/VBoxContainer/MarginContainer2/HBoxContainer/VBoxContainer/ShowClouds")
	showCloudsButton.pressed = currentBlueprint.getClouds()
	
	self.visible = true
	if container.get_child_count() > 0:
		for c in container.get_children():
			c.visible = false
			c.queue_free()
			
	for l in currentBlueprint.getLayers():
		var p = LayerPanel.instance()
		container.add_child(p)
		createPanelSelectionSignal(p)
		
		# Add events and set name to new layer
		p.setLabel(l.name)
		p.setLayer(l)
		
		for event in l.getEvents():
			var eventPanel = p.addPanel(event)
			createEventSelectionSignal(eventPanel)
		
		# Set up event panels signals
		
	blueprintLibraryPanel.loadBlueprints()

func _input(event):
	
	if event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_DELETE and selectedEvent != null:
			for layer in currentBlueprint.getLayers():
				layer.removeEvent(selectedEvent.layerEvent)
				selectedEvent.visible = false
				selectedEvent.queue_free()
			
			eventSettings.visible = false
			currentPlanet.applyBlueprint()
			

func createEventSelectionSignal(instance):
		instance.add_user_signal("eventSelected", ["param", TYPE_OBJECT])
		instance.connect("eventSelected", self, "_eventSelection")
		
func createPanelSelectionSignal(instance):
		instance.add_user_signal("selected", ["param", TYPE_OBJECT])
		instance.connect("selected", self, "_selection")

func _eventSelection(eventPanel):
	selectedEvent = eventPanel
	
	eventSettings.updateSettings(eventPanel.layerEvent)
	eventSettings.visible = true


func _selection(layerPanel):
	if selectedLayers.find(layerPanel) == -1:
		layerPanel.selected(true)
		
		if !Input.is_key_pressed(KEY_SHIFT):
			while !selectedLayers.empty():
				var layer = selectedLayers.back()
				if layer != null:
					layer.selected(false)
				selectedLayers.pop_back()
		
		selectedLayers.append(layerPanel)
	else:
		layerPanel.selected(false)
		selectedLayers.erase(layerPanel)
	print(selectedLayers)
	
func _on_AddFill_pressed():
	# Blink red if no layer selected
	if selectedLayers.size() == 0:
		var tween = self.get_node("Panel/VBoxContainer/ScrollContainer/Tween")
		tween.remove_all()
		tween.interpolate_property(container.get_parent(), "modulate",
				Color.white, Color.red, 0.3,
				Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.interpolate_property(container.get_parent(), "modulate",
				Color.red, Color.white, 0.3,
				Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()
	else:
		for layerPanel in selectedLayers:
			var event = layerPanel.getLayer().addFill(Color.red)
		
			var eventPanel = layerPanel.addPanel(event)
			createEventSelectionSignal(eventPanel)
			
			currentPlanet.applyBlueprint()
			
			eventSettings.updateSettings(eventPanel.layerEvent)
			eventSettings.visible = true
	
	pass # Replace with function body.

func _on_AddNoise_pressed():
	# Blink red if no layer selected
	if selectedLayers.size() == 0:
		var tween = self.get_node("Panel/VBoxContainer/ScrollContainer/Tween")
		tween.remove_all()
		tween.interpolate_property(container.get_parent(), "modulate",
				Color.white, Color.red, 0.3,
				Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.interpolate_property(container.get_parent(), "modulate",
				Color.red, Color.white, 0.3,
				Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()
	else:
		for layerPanel in selectedLayers:
			var event = layerPanel.getLayer().addNoise(1.5, 5, Color.green)
			
			var eventPanel = layerPanel.addPanel(event)
			createEventSelectionSignal(eventPanel)
			
			eventSettings.updateSettings(eventPanel.layerEvent)
			eventSettings.visible = true
			
			currentPlanet.applyBlueprint()
	pass # Replace with function body.

func _on_ShowClouds_toggled(button_pressed):
	currentBlueprint.setClouds(button_pressed)
	currentPlanet.applyBlueprint()
	pass # Replace with function body.

func _on_Save_pressed():
	BlueprintLibrary.saveBlueprint(currentBlueprint, blueprintNameLabel.text)
	blueprintLibraryPanel.loadBlueprints()
	pass # Replace with function body.

func _on_Load_pressed():
	var selectedBlueprint = blueprintLibraryPanel.getSelectedBlueprint()
	if selectedBlueprint != null:
		self.currentBlueprint = selectedBlueprint
		self.currentPlanet.blueprint = self.currentBlueprint
		currentPlanet.applyBlueprint(self.currentBlueprint)
		showPlanetBlueprint(self.currentPlanet)
	pass # Replace with function body.

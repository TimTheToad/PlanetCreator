extends Panel

onready var vbox = get_node("VBoxContainer")

var layerEvent
	
func updateSettings(event):
	self.layerEvent = event
	clearSettings()
	match event.type:
		0:
			createFillSettings(event)
			pass
		1:
			createNoiseSettings(event)
			pass
	
func clearSettings():
	while vbox.get_child_count() > 1:
		var child = vbox.get_child(1)
		vbox.remove_child(child)
		child.visible = false
		child.queue_free()

func createFillSettings(event):
	var colPicker = ColorPickerButton.new()
	colPicker.color = event.color
	vbox.add_child(colPicker)
	colPicker.connect("color_changed", self, "_updateColorFill")
	
	pass

func createNoiseSettings(event):
	var slider = createSlider("Period", event.period, 10, 0.1, 0.1)
	slider.connect("value_changed", self, "_updatePeriod")
	
	slider = createSlider("Octaves", event.octave, 6, 0, 1)
	slider.connect("value_changed", self, "_updateOctave")
	
	var colPicker = ColorPickerButton.new()
	colPicker.color = event.color
	vbox.add_child(colPicker)
	colPicker.connect("color_changed", self, "_updateColorNoise")
	pass

func createSlider(name, value, maxVal, minVal, step):
	var hbox = HBoxContainer.new()
	
	var slider = HSlider.new()
	slider.value = value
	slider.min_value = minVal
	slider.step = step
	slider.max_value = maxVal
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var label = Label.new()
	label.text = name
	
	hbox.add_child(label)
	hbox.add_child(slider)
	vbox.add_child(hbox)
	
	return slider

func _updateColorFill(color):
	self.layerEvent.setUpdated(true)
	self.layerEvent.color = color

func _updatePeriod(period):
	self.layerEvent.setUpdated(true)
	self.layerEvent.period = period

func _updateOctave(octave):
	self.layerEvent.setUpdated(true)
	self.layerEvent.octave = octave

func _updateColorNoise(color):
	self.layerEvent.setUpdated(true)
	self.layerEvent.color = color

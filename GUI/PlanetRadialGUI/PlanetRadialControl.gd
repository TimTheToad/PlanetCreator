extends Control

var dirLayerIcons

var radius = 128

var backIcon = preload("res://Assets/Icons/back.png")

func init(position, radius = 128):
	self.radius = radius
	self.rect_position = position

func _ready():
	
	for child in self.get_children():
		child.visible = false
	
	self.get_node("StartButtons").visible = true
	var startButtons = self.get_node("StartButtons").get_children()
	var layerButtons = self.get_node("LayerButtons").get_children()
	var eventButtons = self.get_node("EventButtons").get_children()
	var fillButtons = self.get_node("FillButtons").get_children()
	var noiseButtons = self.get_node("NoiseButtons").get_children()
	
	positionButtons(PI * 0.5, startButtons)
	positionButtons(PI * 0.5, layerButtons)
	positionButtons(PI * 0.5, eventButtons)
	positionButtons(PI * 0.5, fillButtons)
	positionButtons(PI * 0.5, noiseButtons)
	
	_connectJump(layerButtons[0], 0)
	_connectJump(eventButtons[0], 1)
	_connectJump(fillButtons[0], 2)
	_connectJump(noiseButtons[0], 2)
	
	_connectAllJump(startButtons.slice(1, startButtons.size()), 1)
	_connectAllJump(layerButtons.slice(1, layerButtons.size()), 2)
	
	_connectJump(eventButtons[1], 3) # FillButtons
	_connectJump(eventButtons[2], 4) # NoiseButtons
	
		
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


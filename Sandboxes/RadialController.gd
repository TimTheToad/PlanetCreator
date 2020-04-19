extends Control
signal my_signal

# Declare member variables here. Examples:
onready var historyScene = preload("res://GUI/HistoryPanel/HistoryPanel.tscn")
onready var historyInstance = historyScene.instance()

onready var alternateViewScene =  preload("res://GUI/AlternateView/AlternateView.tscn")
onready var alternateViewInstance = alternateViewScene.instance()

onready var textureViewerScene =  preload("res://GUI/TerrainManipulation/TextureViewer.tscn")
onready var textureViewerInstance = textureViewerScene.instance()
onready var buttons = [
	["History", historyInstance, PRESET_CENTER],
	["Alternate view", alternateViewInstance, PRESET_TOP_RIGHT],
	["Texture viewer", textureViewerInstance, PRESET_TOP_LEFT],
]
var radius = 50
var points
onready var buttonGroup = get_child(0)
onready var masterControl = self.get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	self.call_deferred("add_child", historyInstance)
	self.call_deferred("add_child", alternateViewInstance)
	self.call_deferred("add_child", textureViewerInstance)
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	masterControl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	buttonGroup.visible = false

	for item in buttons:
		var instance = Button.new()
		instance.text = item[0]
		instance.connect("pressed", self, "_showWindow", [item[1], item[2]])
		instance.mouse_filter = Control.MOUSE_FILTER_STOP
		buttonGroup.add_child(instance)
	buttonGroup.mouse_filter = Control.MOUSE_FILTER_IGNORE
#	buttonGroup.connect("my_signal", self, "_OnRadialRelease")
	points = 360 / buttonGroup.get_child_count()
	
	pass # Replace with function body.

var radialReleased = false
var isHovered = false

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("Radial"):
			buttonGroup.visible = true
			radialReleased = false
			PositionButtonsInRadial(event.position)
		elif !event.is_action_pressed("Radial"):
			radialReleased = true

	if event is InputEventKey:
		if event.is_action_pressed("ui_cancel"):
			buttonGroup.visible = false
		
	pass

func _process(delta):
	
	if radialReleased:
		for button in buttonGroup.get_children():
			if button.is_hovered():
				isHovered = true
				button.emit_signal("pressed")
			else:
				isHovered = false
	if radialReleased and !isHovered:
		buttonGroup.visible = false

func PositionButtonsInRadial(mousePos):
	var iterator = 0
	buttonGroup.rect_global_position = mousePos
	
	for button in buttonGroup.get_children():
		var offsetXY = Vector2(radius * cos(deg2rad(points) * iterator), radius * sin(deg2rad(points) * iterator))
		button.rect_position = Vector2(offsetXY.x + (radius * cos(deg2rad(points) * iterator)), offsetXY.y + (radius * sin(deg2rad(points) * iterator)))
		iterator += 1
	pass
	
func _showWindow(instance, anchorPreset):
	instance.visible = true
	instance.set_anchors_preset(anchorPreset, true);
	buttonGroup.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

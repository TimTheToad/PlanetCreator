extends Control

onready var historyScene = preload("res://GUI/HistoryPanel/HistoryPanel.tscn")
onready var historyInstance = historyScene.instance()

onready var PlanetSettingsScene = preload("res://GUI/PlanetSettings/PlanetSettingsPanel.tscn")
onready var PlanetSettingsInstance = PlanetSettingsScene.instance()

onready var alternateViewScene =  preload("res://GUI/AlternateView/AlternateView.tscn")
onready var alternateViewInstance = alternateViewScene.instance()

onready var textureViewerScene =  preload("res://GUI/TerrainManipulation/TextureViewer.tscn")
onready var textureViewerInstance = textureViewerScene.instance()

onready var boxContainer = get_child(0).get_child(0).get_child(0).get_child(1)
onready var buttons = [
	["History", historyInstance, PRESET_CENTER],
	["Planet Settings", PlanetSettingsInstance, PRESET_CENTER],
	["Alternate view", alternateViewInstance, PRESET_TOP_RIGHT],
	["Texture viewer", textureViewerInstance, PRESET_TOP_LEFT],
]

func getHistoryPanel():
	return historyInstance

# Called when the node enters the scene tree for the first time.
func _ready():
	self.call_deferred("add_child", historyInstance)
	self.call_deferred("add_child", PlanetSettingsInstance)
	self.call_deferred("add_child", alternateViewInstance)
	self.call_deferred("add_child", textureViewerInstance)
	
	for item in buttons:
		var instance = Button.new()
		instance.text = item[0]
		instance.connect("pressed", self, "_showWindow", [item[1], item[2]])
		boxContainer.add_child(instance)
	pass # Replace with function body.

func _showWindow(instance, anchorPreset):
	instance.visible = true
	instance.set_anchors_preset(anchorPreset, true);

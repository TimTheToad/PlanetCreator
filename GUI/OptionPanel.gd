extends Control

onready var worldScene = preload("res://GUI/PanelFolder/TestPanel.tscn")
onready var worldInstance = worldScene.instance()

onready var PlanetSettingsScene = preload("res://GUI/PlanetSettings/PlanetSettingsPanel.tscn")
onready var PlanetSettingsInstance = PlanetSettingsScene.instance()

onready var alternateViewScene =  preload("res://GUI/AlternateView/AlternateView.tscn")
onready var alternateViewInstance = alternateViewScene.instance()

onready var boxContainer = get_child(0).get_child(0).get_child(0).get_child(1)
onready var parent = get_parent()
onready var buttons = [
	["History", "_WorldPopup"],
	["Planet Settings", "_PlanetSettings"],
	["Alternate view", "_AlternateView"]
]

# Called when the node enters the scene tree for the first time.
func _ready():
	parent.call_deferred("add_child", worldInstance)
	parent.call_deferred("add_child", PlanetSettingsInstance)
	
	parent.call_deferred("add_child", alternateViewInstance)
	var root = get_parent().get_parent();
	alternateViewInstance.viewportTex = root.get_node("Viewport").get_texture()
	
	for item in buttons:
		var instance = Button.new()
		instance.text = item[0]
		instance.connect("pressed", self, item[1])
		boxContainer.add_child(instance)
	pass # Replace with function body.

func _AlternateView():
	#PlanetSettingsInstance.showWindow()
	alternateViewInstance.visible = true
	alternateViewInstance.set_anchors_preset(PRESET_BOTTOM_RIGHT, true);

func _PlanetSettings():
	#PlanetSettingsInstance.showWindow()
	PlanetSettingsInstance.visible = true
	PlanetSettingsInstance.anchor_left = 0.5
	PlanetSettingsInstance.anchor_top = 0.5
	

func _WorldPopup():
	#worldInstance._showWindow()
	worldInstance.visible = true
	worldInstance.anchor_left = 0.5
	worldInstance.anchor_top = 0.5
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var worldScene = preload("res://GUI/PanelFolder/TestPanel.tscn")
onready var worldInstance = worldScene.instance()

onready var PlanetSettingsScene = preload("res://GUI/PlanetSettings/PlanetSettingsPanel.tscn")
onready var PlanetSettingsInstance = PlanetSettingsScene.instance()

onready var boxContainer = get_child(0).get_child(0).get_child(0).get_child(1)
onready var parent = get_parent()
onready var buttons = [["World", "_WorldPopup"], ["Planet Settings", "_PlanetSettings"]]
# Called when the node enters the scene tree for the first time.
func _ready():
	parent.call_deferred("add_child", worldInstance)
	parent.call_deferred("add_child", PlanetSettingsInstance)
	
	for item in buttons:
		var instance = Button.new()
		instance.text = item[0]
		instance.connect("pressed", self, item[1])
		boxContainer.add_child(instance)
	pass # Replace with function body.

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
	print("snopp")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

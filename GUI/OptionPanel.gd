extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var boxContainer = get_child(0).get_child(0).get_child(0).get_child(1)
onready var worldScene = preload("res://GUI/TestPanel.tscn")
onready var worldInstance = worldScene.instance()
onready var parent = get_parent()
onready var buttons = [["World", "_WorldPopup"], ["Add Item", "_AddItemPopup"]]
# Called when the node enters the scene tree for the first time.
func _ready():
	parent.call_deferred("add_child", worldInstance)
	
	for item in buttons:
		var instance = Button.new()
		instance.text = item[0]
		instance.connect("pressed", self, item[1])
		boxContainer.add_child(instance)
	pass # Replace with function body.


func _WorldPopup():
	worldInstance._showWindow()
	print("snopp")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

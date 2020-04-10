extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var boxContainer = self.get_node("PanelContainer/Panel/ScrollContainer/VBoxContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _showWindow():
	popup()
	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _input(event):

	pass
	
#func _process(delta):
#	pass

func AddHistoryItem(name):
	var button = Button.new()
	button.text = name
	boxContainer.add_child(button)
	
func RemoveHistoryItem():
	pass

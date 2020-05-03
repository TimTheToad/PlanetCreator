extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var buttons = [get_node("HBoxContainer/Button"), get_node("HBoxContainer/Button2"), get_node("HBoxContainer/Button3")]
onready var planetHolder = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	print(planetHolder.name)
	buttons[0].connect("pressed", planetHolder, "sortBySize")
	buttons[1].connect("pressed", planetHolder, "sortByName")
	buttons[2].connect("pressed", planetHolder, "sortByLastModified")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

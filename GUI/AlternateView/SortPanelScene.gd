extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var items = [get_node("HBoxContainer/Button"), get_node("HBoxContainer/Button2"), get_node("HBoxContainer/LineEdit"), get_node("HBoxContainer/Button4")]
onready var planetHolder = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	print(planetHolder.name)
	items[0].connect("pressed", planetHolder, "sortBySize")
	items[1].connect("pressed", planetHolder, "sortByName")
	items[2].connect("text_changed", planetHolder, "searchPlanet")
	items[3].connect("pressed", planetHolder, "sortByLastEdited")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button3_pressed():
	items[2].clear()
	pass # Replace with function body.

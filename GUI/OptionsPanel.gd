extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var slider = preload("res://Slider.tscn")
onready var elementContainer = get_child(0).get_child(1)
# Called when the node enters the scene tree for the first time.
func _ready():
	var button = Button.new()
	elementContainer.add_child(button)
	
	button.connect("pressed", self, "_OpenSlider")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _OpenSlider():
	pass

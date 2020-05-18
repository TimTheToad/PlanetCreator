extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var helpText = get_tree().current_scene.get_node("Control/HelpText")

#onready var cameraHolder
var time
var currentCamera
var chosenText = 1
# 0 empty, 1 first, 2 double clicked planet, 3 radial planet, 4 radial planet layers, 5 radial planet fill, 6 radial planet pattern 
var textArr = ["", "Double click any planet to orbit around it and begin editing that planet!", 
"Click \"Add Layer\" to add one of the three avalable layers: Water, Ground and Lava \nClick on \"Advanced\" to get to the blueprint editor \nFinaly click on the back arrow to exit out from the planet editing menu",
"Click on one of the three icons to add the corresponding layer on the planet \"Fire\" for Lava, \"Water\" for Water and \"Ground\" for Ground",
"Click on the \"Bucket\" icon to fill the planet with this chosen layer \nClick on the \"Pattern\" icon to add a pattern of chosen layer",
"Click on the Square Color to choose a color for this layer \nClick on the green checkmark to apply the layer or the \"backarrow\" to undo the layer and return to the previous menu",
"Click on the Square Color to choose a color for this layer \nDrage the \"Period\" dragger to change the size of the pattern \nDrag the \"Octave\" dragger to change the hardness of the pattern \nClick on the green checkmark to apply the layer or the \"backarrow\" to undo the layer and return to the previous menu",
]


func _ready():
	time = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	var currentText
	currentText = textArr[chosenText]
	# first float is the freq and the second is the span. Change the last float for how dark it should be, lower = darker
	var alpha = sin(time * 1.0 + (delta / 15.0)) * 0.5 + 0.8 
	alpha = Color(1, 1, 1, alpha)
	currentText = "[color=#" + alpha.to_html(true) + "]" + currentText + "[/color]"
	helpText.bbcode_text = currentText
#	pass

func showToggle(button_pressed):
	helpText.visible = button_pressed


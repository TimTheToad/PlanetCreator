extends "Planet.gd"


#var textures = $Textures
var viewports

var layers

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	pass # Replace with function body.

func generateNoiseTexture(period, octaves):
	
	var image = Image.new()
	image.create(1024, 512, true, Image.FORMAT_RGBA8)
	image.fill(Color())
	

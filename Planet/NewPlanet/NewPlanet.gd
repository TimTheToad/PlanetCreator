extends "Planet.gd"


#var textures = $Textures
var viewports

var layers

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	pass # Replace with function body.

func generateNoiseTexture(period, octaves):
	var noise = OpenSimplexNoise.new()
	noise.period = period
	noise.octaves = 5

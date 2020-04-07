extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var MAX_HEIGHT = 1.0
var MIN_HEIGHT = 0.0

var MAX_WATER_AMOUNT = 1.0
var MIN_WATER_AMOUNT = 0.0

var MAX_MOUNTAIN_AMOUNT = 1.0
var MIN_MOUNTAIN_AMOUNT = 0.0

var MAX_SNOW_AMOUNT = 1.0
var MIN_SNOW_AMOUNT = 0.0

onready var material = self.get_surface_material(0);

# Called when the node enters the scene tree for the first time.
func _ready():
	randomizePlanetColors()
	pass # Replace with function body.

func randomizePlanetColors():
	self.setGroundColor(randomizeColor())
	self.setWaterColor(randomizeColor())
	self.setMountainColor(randomizeColor())
	self.setSnowColor(randomizeColor())
	
func randomizeColor():
	randomize()
	var color = Color(randf(), randf(), randf(), 1.0)
	return color

func setGroundColor(color):
	material.set_shader_param("ground_color", color)

func setWaterColor(color):
	material.set_shader_param("water_color", color)

func setMountainColor(color):
	material.set_shader_param("mountain_color", color)
	
func setSnowColor(color):
	material.set_shader_param("snow_color", color)

func setSnowThreshold(threshold):
	if threshold >= MIN_SNOW_AMOUNT and threshold <= MAX_SNOW_AMOUNT:
		material.set_shader_param("snow_amount", threshold)
	else:
		print("mountain threshold must be between: ", MIN_HEIGHT, " - ", MAX_HEIGHT)
	pass

func setMountainThreshold(threshold):
	if threshold >= MIN_MOUNTAIN_AMOUNT and threshold <= MAX_MOUNTAIN_AMOUNT:
		material.set_shader_param("mountain_amount", threshold)
	else:
		print("mountain threshold must be between: ", MIN_HEIGHT, " - ", MAX_HEIGHT)
	pass

func setWaterThreshold(threshold):
	if threshold >= MIN_WATER_AMOUNT and threshold <= MAX_WATER_AMOUNT:
		material.set_shader_param("water_amount", threshold)
	else:
		print("water threshold must be between: ", MIN_HEIGHT, " - ", MAX_HEIGHT)
	pass

func setHeight(height):
	if height >= MIN_HEIGHT and height <= MAX_HEIGHT:
		material.set_shader_param("slider", height)
	else:
		print("height values must be between: ", MIN_HEIGHT, " - ", MAX_HEIGHT)
	pass

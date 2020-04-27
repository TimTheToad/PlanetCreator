extends "Planet.gd"


onready var viewports = get_node("Textures").get_children()

var meshes = []

var blueprint

enum EventType {
	FILL,
	NOISE,
	CLEAR
}

enum LayerType {
	BASE,
	LIQUID,
	LAVA,
	CLOUD
}

var eventQueue = []


# Called when the node enters the scene tree for the first time.
func _ready():
	meshes = self.get_node("Meshes").get_children()
	
	_hideChildren(viewports[LayerType.BASE])
	_hideChildren(viewports[LayerType.LIQUID])
	
	blueprint = Blueprint.new()
	blueprint.addLayer("Base", LayerType.BASE, self)
	blueprint.addLayer("Liquid", LayerType.LIQUID,  self)
	blueprint.addLayer("Lava", LayerType.LAVA, self)
	
#	PlanetLayer.new()
#	var color = Color(0.4, 0.4, 0.4, 1.0)
#	_fillColorLayer(viewports[LayerType.BASE], color)
	
#	pl0.addFill(Color.green)
#	pl0.addNoise(1.0, 4, Color.green)
#	pl0.addNoise(1.5, 4, Color.lawngreen)
#
#	pl1.addNoise(0.4, 8, Color.aqua)
#	pl2.addNoise(0.7, 5, Color.red)
	pass # Replace with function body.

func showClouds(show):
	if show:
		meshes[LayerType.CLOUD].visible = true
	else:
		meshes[LayerType.CLOUD].visible = false

func applyBlueprint():
	self.blueprint.apply(self)

func queueClear(layerIndex):
	eventQueue.append([EventType.CLEAR, layerIndex])

func queueFill(layerIndex, color):
	eventQueue.append([EventType.FILL, layerIndex, color])

func queueNoise(layerIndex, period, octaves, color):
	eventQueue.append([EventType.NOISE, layerIndex, period, octaves, color])
	
func _process(dt):
	
	if blueprint:
		if blueprint.hasUpdate():
			blueprint.apply(self)
	
	if eventQueue.size() > 0:
		var e = eventQueue.front()
	
		if e:
			match e[0]:
				EventType.CLEAR:
					_clearLayer(e[1])
				EventType.FILL:
					_fillColorLayer(e[1], e[2])
					pass
				EventType.NOISE:
					_renderNoiseLayer(e[1], e[2], e[3], e[4])
	
			eventQueue.pop_front()
		pass

func getMaterial(type):
	return meshes[type].material_override

func _hideChildren(parent):
	var children = parent.get_children()
		
	if children:
		for child in children:
			child.visible = false

func _clearLayer(layerIndex):
	var viewport = viewports[layerIndex]
	viewport.render_target_clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
	viewport.render_target_update_mode = Viewport.UPDATE_ONCE

func _fillColorLayer(layerIndex, color = null):
	var viewport = viewports[layerIndex]
	_hideChildren(viewport)
	var cRect = viewport.get_node("FillColor")
	cRect.visible = true
	
	if color:
		cRect.color = color
		
	viewport.render_target_update_mode = Viewport.UPDATE_ONCE
	
	
func _renderNoiseLayer(layerIndex, period, octaves, color):
	var viewport = viewports[layerIndex]
	_hideChildren(viewport)
	var cRect = viewport.get_node("NoiseBrush")
	cRect.visible = true
	var mat = cRect.material
	
	mat.set_shader_param("period", period)
	mat.set_shader_param("octaves", octaves)
	mat.set_shader_param("color", color)
	
	viewport.render_target_update_mode = Viewport.UPDATE_ONCE
	pass
	

extends "Planet.gd"


onready var viewports = get_node("Textures").get_children()

# Brushes
onready var noiseBrush = preload("res://Planet/NewPlanet/Brushes/NoiseBrush.tscn")


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
	
	blueprint = Blueprint.new()
	blueprint.addLayer("Base", LayerType.BASE)
	blueprint.addLayer("Liquid", LayerType.LIQUID)
	blueprint.addLayer("Lava", LayerType.LAVA)
	pass # Replace with function body.

func setCloudColor(color):
	meshes[LayerType.CLOUD].material_override.albedo_color = color
	
func showClouds(show):
	if show:
		meshes[LayerType.CLOUD].visible = true
	else:
		meshes[LayerType.CLOUD].visible = false

func applyBlueprint():
	for layer in self.blueprint.getLayers():
		var viewport = viewports[layer.layerIndex]
		# Remove older brushes
		for child in viewport.get_children():
			child.visible = false
			child.queue_free()
		
		# Add new brushes
		for event in layer.getEvents():
			match event.type:
				EventType.FILL:
					_createFillBrush(viewport, event)
				EventType.NOISE:
					_createNoiseBrush(viewport, event)
		viewport.render_target_update_mode = Viewport.UPDATE_ONCE
	
	for moon in self.blueprint.moons:
		addMoon(moon)
		
func updateLayer(layer):
	var viewport = viewports[layer.layerIndex]
	print(self.name)
	var brushes = viewport.get_children()
	var events = layer.getEvents()
	for i in range(events.size()):
		var event = events[i]
		match event.type:
			EventType.FILL:
				var brush = viewport.get_child(i)
				brush.color = event.color
				brush.anchor_right = 1.0
				brush.anchor_bottom = 1.0
			EventType.NOISE:
				var brush = viewport.get_child(i)
				var mat = brush.material
				
				mat.set_shader_param("period", event.period)
				mat.set_shader_param("octaves", event.octave)
				mat.set_shader_param("color", event.color)
	
	viewport.render_target_update_mode = Viewport.UPDATE_ONCE

func addMoon(moon):
	self.add_child(moon)

func _createFillBrush(viewport, event):
	var brush = ColorRect.new()
	brush.color = event.color
	brush.anchor_right = 1.0
	brush.anchor_bottom = 1.0
	
	viewport.add_child(brush)
	
func _createNoiseBrush(viewport, event):
	var brush = noiseBrush.instance()
	var mat = brush.material.duplicate()
	
	mat.set_shader_param("period", event.period)
	mat.set_shader_param("octaves", event.octave)
	mat.set_shader_param("color", event.color)
	
	brush.material = mat
	
	viewport.add_child(brush)
	
func _process(dt):
	if blueprint:
		blueprint.apply(self)


func getMaterial(type):
	return meshes[type].material_override

func _hideChildren(parent):
	var children = parent.get_children()
		
	if children:
		for child in children:
			child.visible = false

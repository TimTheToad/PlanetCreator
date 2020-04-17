extends "Planet.gd"

onready var viewports = get_node("Textures").get_children()

var meshes = []

enum LayerType {
	BASE,
	LIQUID,
	CLOUD
}

# Called when the node enters the scene tree for the first time.
func _ready():
	meshes = self.get_node("Meshes").get_children()
	
	_hideChildren(viewports[LayerType.BASE])
	_hideChildren(viewports[LayerType.LIQUID])
	
	var color = Color(0.4, 0.4, 0.4, 1.0)
	_fillColorLayer(viewports[LayerType.BASE], color)
	
	var liquidMat = getMaterial(LayerType.LIQUID)
	liquidMat.emission_enabled = true
	liquidMat.emission = Color(0.4, 0.4, 1.0, 1.0)
	liquidMat.emission_energy = 3.0
	pass # Replace with function body.

func _input(event):
	
	if event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_1:
			_hideChildren(viewports[LayerType.BASE])
			_fillColorLayer(viewports[LayerType.BASE])
		
		if event.scancode == KEY_Q:
			addTexture(LayerType.BASE)
			
		if event.scancode == KEY_W:
			addTexture(LayerType.LIQUID)

func getMaterial(type):
	return meshes[type].material_override

func addTexture(type):
	var color = Color(1.0, 1.0, 1.0, 1.0)
	_hideChildren(viewports[type])
	
	if type == LayerType.BASE:
		color = Color(0.2,  0.5 + randf() * 0.3, 0.2, 0.5 + randf() * 0.5)
		_renderNoiseLayer(viewports[LayerType.BASE], 1.0 + randf() * 1.5, 5, color)
	elif type == LayerType.LIQUID:
		color = Color(0.1, 0.1, 0.5, 1.0)
		_renderNoiseLayer(viewports[LayerType.LIQUID], 0.5 + randf() * 1.5, 5, color)
		
	pass

func _hideChildren(parent):
	var children = parent.get_children()
		
	if children:
		for child in children:
			child.visible = false
		

func _fillColorLayer(viewport, color = null):
	var cRect = viewport.get_node("FillColor")
	cRect.visible = true
	
	if color:
		cRect.color = color
		
	viewport.render_target_update_mode = Viewport.UPDATE_ONCE
	
	
func _renderNoiseLayer(viewport, period, octaves, color):
	var cRect = viewport.get_node("NoiseBrush")
	cRect.visible = true
	var mat = cRect.material
	
	mat.set_shader_param("period", 0.5 + randf() * 1.5)
	mat.set_shader_param("octaves", 5)
	mat.set_shader_param("color", color)
	
	viewport.render_target_update_mode = Viewport.UPDATE_ONCE
	pass
	
	
	

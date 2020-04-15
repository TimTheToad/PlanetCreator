extends Control

onready var texContainer = $VBoxContainer/ViewportTex

onready var rootScene = get_tree().get_current_scene()
var viewport
var camera


# Called when the node enters the scene tree for the first time.
func _ready():
	# Create Vewport
	viewport = Viewport.new();
	viewport.size = texContainer.rect_size
	
	#Create Camera
	camera = Camera.new()
	camera.translate(Vector3(0.0, 0.0, 10.0))
	
	# Set up relations
	viewport.add_child(camera)
	rootScene.add_child(viewport)
	
	# Set up texture container
	texContainer.flip_v = true;
	texContainer.texture = viewport.get_texture()

	pass # Replace with function body.

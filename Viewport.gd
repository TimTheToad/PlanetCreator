extends Viewport


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var img 
onready var texture = get_node("TextureRect")
onready var camera = get_node("MeshInstance/Camera")
# Called when the node enters the scene tree for the first time.
func _ready():
	img =  camera.get_viewport().get_texture().get_data()
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	texture.texture = tex
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

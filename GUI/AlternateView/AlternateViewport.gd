extends Control

onready var viewportTexContainer = $VBoxContainer/ViewportTex

export(Texture) var viewportTex;

# Called when the node enters the scene tree for the first time.
func _ready():
	if viewportTex:
		viewportTexContainer.texture = viewportTex;
	pass # Replace with function body.

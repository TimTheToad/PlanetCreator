extends Control

onready var texContainer = $VBoxContainer/ViewportTex
onready var brushTex = preload("res://icon.png")

onready var rootScene = get_tree().get_current_scene()
var viewport
var camera
var cRect
var brushSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create Vewport
	viewport = Viewport.new();
	viewport.size = texContainer.rect_size
	
	#Create ColorRect
	cRect = ColorRect.new()
	cRect.anchor_bottom = 1.0;
	cRect.anchor_right = 1.0;
	
	brushSprite = Sprite.new()
	brushSprite.texture = brushTex
	brushSprite.position = Vector2(128, 128)
	
	
	# Set up relations
	viewport.add_child(cRect)
	viewport.add_child(brushSprite)
	rootScene.add_child(viewport)
	
	# Set up texture container
	texContainer.flip_v = true;
	texContainer.texture = viewport.get_texture()
	cRect.visible = false;
	pass # Replace with function body.


func _input(event):
	
	if event is InputEventKey and event.is_pressed():
		
		if event.scancode == KEY_DOWN:
			viewport.render_target_update_mode = Viewport.UPDATE_ONCE
			viewport.render_target_clear_mode = Viewport.CLEAR_MODE_NEVER
			
			brushSprite.translate(Vector2(0, 2))
			
		if event.scancode == KEY_UP:
			viewport.render_target_update_mode = Viewport.UPDATE_ONCE
			viewport.render_target_clear_mode = Viewport.CLEAR_MODE_NEVER
			brushSprite.translate(Vector2(0, -2))

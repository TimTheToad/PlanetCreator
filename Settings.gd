extends Panel

onready var planetMesh = get_parent().get_parent().get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func _input(event):
	
	if event is InputEventKey:
		if event.is_action_pressed("Planet"):
			var mat = planetMesh.get_surface_material(0)
			mat.set_shader_param("slider", 1.0)
			
			var instance = MeshInstance.new()
			var sphereMesh = SphereMesh.new()
			instance.mesh = sphereMesh
			
			instance.global_translate(Vector3(1.0, 0.0, 0.0))
			
			planetMesh.add_child(instance)

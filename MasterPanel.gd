extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



export(PackedScene) var scene

# Called when the node enters the scene tree for the first time.
func _ready():
	var exitButton = get_child(0)
	exitButton.connect("pressed", self, "_exit")
	var instance = scene.instance()
	self.add_child(instance)
	self.move_child(exitButton, 1)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	
	
	#pass

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_T: 
			self.set_visible(true)
			
		
		
	
	pass

func _exit():
	self.set_visible(false)
	pass

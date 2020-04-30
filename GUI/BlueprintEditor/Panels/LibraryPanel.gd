extends Panel

onready var container = get_node("ScrollContainer/VBoxContainer")

func getSelectedBlueprint():
	var index = 0
	for child in container.get_children():
		if child.pressed:
			return BlueprintLibrary.blueprints[index]
		index += 1
			

func loadBlueprints():
	for child in container.get_children():
		container.remove_child(child)
	
	for blueprint in BlueprintLibrary.blueprints:
		var button = Button.new()
		button.toggle_mode = true
		button.text = blueprint.title
		button.align = button.ALIGN_CENTER
		
		button.connect("button_down", self, "_deselectAll")
		
		container.add_child(button)

func _deselectAll():
	for child in container.get_children():
		child.pressed = false

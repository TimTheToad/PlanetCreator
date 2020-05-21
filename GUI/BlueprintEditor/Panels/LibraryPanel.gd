extends Panel

onready var container = get_node("ScrollContainer/VBoxContainer")
onready var scrollContainer = get_node("ScrollContainer")

onready var preview = get_node("PlanetPreview")

func getSelectedBlueprint():
	var index = 0
	for child in container.get_children():
		if child.pressed:
			return BlueprintLibrary.blueprints[index]
		index += 1
	
	# only happens when no blueprint is selected
	
	var tween = self.get_node("Tween")
	tween.remove_all()
	tween.interpolate_property(scrollContainer, "modulate",
			Color.white, Color.red, 0.3,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(scrollContainer, "modulate",
			Color.red, Color.white, 0.3,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func loadBlueprints():
	for child in container.get_children():
		container.remove_child(child)
	
	for blueprint in BlueprintLibrary.blueprints:
		var button = Button.new()
		button.toggle_mode = true
		button.text = blueprint.title
		button.align = button.ALIGN_CENTER
		
		button.connect("button_down", self, "_deselectAll")
		button.connect("mouse_entered", preview, "set_visible", [true])
		button.connect("mouse_exited", preview, "set_visible", [false])
		button.connect("mouse_entered", preview, "changeBlueprint", [blueprint])
		
		container.add_child(button)

func _deselectAll():
	for child in container.get_children():
		child.pressed = false

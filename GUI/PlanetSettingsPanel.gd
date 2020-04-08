extends Control


onready var PlanetParams = get_parent().get_parent().get_child(1);

onready var heightSlider = get_node("Panel/MarginContainer/VSplitContainer/Tabs/TabContainer/Sliders/VBoxContainer/Height Slider/HeightSlider")
onready var waterSlider = get_node("Panel/MarginContainer/VSplitContainer/Tabs/TabContainer/Sliders/VBoxContainer/Water Slider/WaterSlider")
onready var mountainSlider = get_node("Panel/MarginContainer/VSplitContainer/Tabs/TabContainer/Sliders/VBoxContainer/Mountain Slider/MountainSlider")
onready var snowSlider = get_node("Panel/MarginContainer/VSplitContainer/Tabs/TabContainer/Sliders/VBoxContainer/Snow Slider/SnowSlider")

func _ready():
	heightSlider.value = PlanetParams.getHeight()
	waterSlider.value = PlanetParams.getWaterThreshold()
	mountainSlider.value = PlanetParams.getMountainThreshold()
	snowSlider.value = PlanetParams.getSnowThreshold()

	pass # Replace with function body.

func _on_HeightSlider_value_changed(value):
	PlanetParams.setHeight(value)
	pass # Replace with function body.

func _on_WaterSlider_value_changed(value):
	PlanetParams.setWaterThreshold(value)
	pass # Replace with function body.

func _on_MountainSlider_value_changed(value):
	PlanetParams.setMountainThreshold(value)
	pass # Replace with function body.

func _on_SnowSlider_value_changed(value):
	PlanetParams.setSnowThreshold(value)
	pass # Replace with function body.

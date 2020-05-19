extends Control

onready var planetMasterScript = get_tree().current_scene.get_node("Planets")
onready var label = get_node("HBoxContainer/Label")

func _ready():
	label.text = String(planetMasterScript.PLANET_COUNT)

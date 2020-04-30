class_name Blueprint extends Reference

var PlanetLayer = preload("res://Planet/NewPlanet/ScriptManagment/PlanetLayer.gd")


var layers = []

var showClouds = false

func setClouds(show):
	showClouds = show

func getClouds():
	return showClouds
	
func getLayers():
	return layers

func apply(planet):
	applyLayers(planet)

	planet.showClouds(showClouds)

func applyLayer(index, planet):
	layers[index].applyLayer(planet, index)

func applyLayers(planet):
	for i in range(layers.size()):
		if layers[i].getUpdated():
			planet.updateLayer(layers[i])

func addLayer(name, index, planet):
	var layer = PlanetLayer.new(name, index, planet)
	layers.append(layer)

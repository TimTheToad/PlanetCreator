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

func hasUpdate():
	var shouldUpdate = false
	for layer in layers:
		if layer.hasUpdate():
			shouldUpdate = true
	
	return shouldUpdate
	
func apply(planet):
	applyLayers(planet)

	planet.showClouds(showClouds)

func applyLayer(index, planet):
	layers[index].applyLayer(planet, index)

func applyLayers(planet):
	for i in range(layers.size()):
		layers[i].applyLayer(planet, i)

func addLayer(name, index, planet):
	var layer = PlanetLayer.new(name, index, planet)
	layers.append(layer)

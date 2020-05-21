class_name Blueprint extends Reference

var PlanetLayer = load("res://Planet/NewPlanet/ScriptManagment/PlanetLayer.gd")

var layers = []
var showClouds = false
var cloudColor = Color.white
var title = "Untitled"
var moons = []

func setClouds(show):
	showClouds = show

func getClouds():
	return showClouds

func getLayer(layerName):
	for layer in layers:
		if layer.name == layerName:
			return layer
			
	return null

func getLayers():
	return layers

func addMoon(planet):
	var moon = Moon.new(planet)
	moons.append(moon)
	pass

func getMoons():
	return moons

func apply(planet):
	applyLayers(planet)

	planet.showClouds(showClouds)

func applyLayer(index, planet):
	layers[index].applyLayer(planet, index)

func applyLayers(planet):
	for i in range(layers.size()):
		if layers[i].getUpdated():
			planet.updateLayer(layers[i])

func addLayerCopy(layer):
	layers.append(layer)
	return layer
	
func addLayer(name, index, icon = null):
	var layer = PlanetLayer.new(name, index, icon)
	layers.append(layer)
	return layer

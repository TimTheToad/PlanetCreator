class_name PlanetLayer extends Reference

var planetClass = load("res://Planet/NewPlanet/NewPlanet.gd")

class LayerEvent extends Reference:
	var update = true
	var type

class FillEvent extends LayerEvent:
	var color
	
	func _init(type, color):
		self.type = type
		self.color = color

class NoiseEvent extends LayerEvent:
	var period
	var octave
	var color
	
	func _init(type, period, octave, color):
		self.type = type
		self.period = period
		self.octave = octave
		self.color = color

var events = []
var name
var layerIndex

func _init(name, index, planet):
	self.name = name
	self.layerIndex = index
	pass

func hasUpdate():
	var shouldUpdate = false
	for event in events:
		if event.update:
			shouldUpdate = true
			event.update = false
			
	return shouldUpdate

func removeEvent(event):
	var index = events.find(event)
	if index != -1:
		events.remove(index)

func getEvents():
	return events	

func addFill(color):
	var e = FillEvent.new(planetClass.EventType.FILL, color)
	events.append(e)
#	events.append(
#		 [
#			planetClass.EventType.FILL,
#			color
#		])
		
	return events.back()
	pass
	
func addNoise(period, octave, color):
	var e = NoiseEvent.new(planetClass.EventType.NOISE, period, octave, color)
	events.append(e)
	
#	events.append(
#		 [
#			planetClass.EventType.NOISE,
#			period,
#			octave,
#			color
#		])
	return events.back()
	pass

func applyLayer(planet, type):
	planet.queueClear(self.layerIndex)
	
	for e in events:
		match e.type:
			planetClass.EventType.FILL:
				planet.queueFill(self.layerIndex, e.color)
			planetClass.EventType.NOISE:
				planet.queueNoise(self.layerIndex, e.period, e.octave, e.color)
	pass

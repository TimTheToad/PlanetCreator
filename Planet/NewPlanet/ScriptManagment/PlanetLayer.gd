class_name PlanetLayer extends Reference

var planetClass = load("res://Planet/NewPlanet/NewPlanet.gd")

class LayerEvent extends Reference:
	var update = false
	var layer
	var type
	
	func setUpdated(updated):
		update = true
		layer.setUpdated(updated)

class FillEvent extends LayerEvent:
	var color
	
	func _init(type, layer, color):
		self.type = type
		self.layer = layer
		self.color = color
		
	func setColor(c):
		self.color = c
		self.setUpdated(true)

class NoiseEvent extends LayerEvent:
	var period
	var octave
	var color
	
	func _init(type, layer,  period, octave, color):
		self.type = type
		self.layer = layer
		self.period = period
		self.octave = octave
		self.color = color
		
	func setPeriod(p):
		self.period = p
		self.setUpdated(true)
		
	func setOctave(o):
		self.octave = o
		self.setUpdated(true)
		
	func setColor(c):
		self.color = c
		self.setUpdated(true)

var events = []
var name
var layerIndex
var update = false
var layerIcon = null

func _init(name, index, icon = null):
	self.name = name
	self.layerIndex = index
	self.layerIcon = icon
	pass

func getUpdated():
	return update

func setUpdated(updated):
	update = true

func _process(dt):
	if update == true:
		update = false

func removeEvent(event):
	var index = events.find(event)
	
	setUpdated(true)
	
	if index != -1:
		events.remove(index)

func getEvents():
	return events	

func addFill(color):
	var e = FillEvent.new(planetClass.EventType.FILL, self, color)
	events.append(e)
	
	setUpdated(true)
	return events.back()
	pass
	
func addNoise(period, octave, color):
	var e = NoiseEvent.new(planetClass.EventType.NOISE, self, period, octave, color)
	events.append(e)
	
	setUpdated(true)
	return events.back()
	pass


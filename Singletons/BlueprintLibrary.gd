extends Node

var blueprints = []

var directory = Directory.new()
var dirPath = "res://BlueprintStorage/"

var eventType = preload("res://Planet/NewPlanet/NewPlanet.gd").EventType

func _init():
	
	var error = directory.open(dirPath)
	if error != OK:
		print("Failed to open directory:", dirPath, "\nerror code: ", error)
	else:
		
		error = directory.list_dir_begin(true, true)
		if error != OK:
			print("Failed to load blueprints from:", dirPath, "\nerror code: ", error)
			return
			
		var fileName = directory.get_next()
		while fileName != "":
			var blueprint = loadBlueprint(fileName)
			self.blueprints.append(blueprint)
			print("Loaded blueprint: ", fileName)
			
			fileName = directory.get_next()
		
func loadBlueprint(fileName):
	
	var file = File.new()
	file.open(dirPath + fileName, File.READ)
	var blueprintDict = JSON.parse(file.get_as_text()).result
	var index = 0
	
	var blueprint = Blueprint.new()
	blueprint.title = blueprintDict["Blueprint"]["Name"]
	
	for layerName in blueprintDict["Blueprint"]["Layers"]:
		
		var layer = blueprint.addLayer(layerName, index)
		index += 1
		
		var layerDict = blueprintDict["Blueprint"]["Layers"][layerName]
		for layerEventName in layerDict:
			var eventDict = layerDict[layerEventName]
			var t = eventDict["type"]
			
			match int(eventDict["type"]):
				eventType.FILL:
					layer.addFill(
						Color(eventDict["color"])
						)
					pass
				eventType.NOISE:
					layer.addNoise(
						eventDict["period"],
						eventDict["octave"],
						Color(eventDict["color"])
						)
					pass
	
	return blueprint

func saveBlueprint(blueprint, fileName):
	blueprint.title = fileName
	blueprints.append(blueprint)
	
	var jsonBlueprint = {}
	jsonBlueprint = {"Blueprint" : { "Name" : fileName, "Layers" : {}}}
	
	var layers = blueprint.getLayers()
	
	#Add moons
	#	for moon in blueprint.getMoons():
	
	# Add layers
	for layer in layers:
		
		# Add layer events
		jsonBlueprint["Blueprint"]["Layers"][layer.name] = {}
		
		var index = 0
		for event in layer.getEvents():
			var eventElement = {}
			
			eventElement["type"] = event.type
			match event.type:
				eventType.FILL:
					eventElement["color"] = event.color.to_html()
				eventType.NOISE:
					eventElement["period"] = event.period
					eventElement["octave"] = event.octave
					eventElement["color"] =  event.color.to_html()
			
			jsonBlueprint["Blueprint"]["Layers"][layer.name][index] = eventElement
			index += 1

		
	var file = File.new()
	file.open(dirPath + fileName + ".json", File.WRITE)
	file.store_string(JSON.print(jsonBlueprint))
	file.close()
	

	
	pass
	
	

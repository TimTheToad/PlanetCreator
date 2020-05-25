extends "AlternateViewSetup.gd"

onready var window = self


var namePanel
var hoveredViewPortContainer
var mouseInView = false

onready var nameEdit = get_node("NamePanel/HBoxContainer/LineEdit")


# Called when the node enters the scene tree for the first time.
func _ready():
	window.visible = false
	namePanel = get_node("NamePanel")
	intiAlternateView()
	
	updateView()
	pass # Replace with function body.
	
func _on_ViewPortContainer_mouse_entered(container):
	hoveredViewPortContainer = container
	mouseInView = true
	pass
	
func _on_ViewPortContainer_mouse_exited():
#	hoveredViewPortContainer = null
#	planet = null
	mouseInView = false
	pass

var selectedPlanet
var pressed
var vPort
var mousePos

func getPlanetInScene(planetName):
	var planets = planetsInScene.get_children()
	for planet in planets:
		if planetName == planet.name:
			return planet
		else:
			return false
	pass

func _input(event):
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if hoveredViewPortContainer:
				vPort = hoveredViewPortContainer.get_child(0)
				mousePos = event.position
		if event.button_index == BUTTON_LEFT:
			if selectedPlanet:
				var planetInScene = getPlanetInScene(selectedPlanet.name)
				if planetInScene:
					radialGUI = planetInScene.get_node("PlanetRadialControl")


		if event.is_pressed():
			pressed = true
		else:
			pressed = false
	if hoveredViewPortContainer:
		if event is InputEventMouseMotion and pressed:
			if selectedPlanet:
				if mouseInView:
					selectedPlanet.rotatePlanet(event.get_relative())
#				vPort.warp_mouse(mousePos)
		
	pass

func getViewPorts():
	return panelContainers
	pass

func _planetUpdateChange(changedPlanet):
	for i in range(planetsInView):
		if changedPlanet.name == planetsInView[i].name:
			planetsInView[i].meshes = changedPlanet.meshes
	pass

func updateView():
	var iter = 0
	for camera in cameras:
		camera.look_at(planetsInView[iter].translation, Vector3(0.0, 1.0, 0.0))
		iter += 1

func _process(delta):
	if not radialGUI and selectedPlanet:
		radialGUI = null
		getPanel(selectedPlanet).set('custom_styles/panel', panelStyleNotSelected)
	pass

func getPanel(planet):
	return planet.get_parent().get_parent().get_parent().get_parent()
	pass


func _selectPlanetName(planet):
	selectedPlanet = planet
	namePanel.visible = true
	getPanel(selectedPlanet).set('custom_styles/panel', panelStyleSelected)
	pass

var planets = []
func sortByName():
	tweenIt(2.0, Color.white, Color.black)
	var planetIndexArr = []
	var planetIndex = 0
	var names = []
	var minId
	for name in nameDic:
		names.append(name)
		planetIndexArr.append(planetIndex)
		planetIndex += 1
		print(names)
	for i in range(names.size()):
		minId = i
		for j in range(i+1, names.size()):
			var maxIt = names[j].length()
			if names[minId][0].to_ascii()[0] > names[j][0].to_ascii()[0]:
				minId = j
			elif names[minId][0].to_ascii()[0] == names[j][0].to_ascii()[0]:
				if names[minId][1].to_ascii()[0] > names[j][1].to_ascii()[0]:
					minId = j
				elif names[minId][1].to_ascii()[0] == names[j][1].to_ascii()[0]:
					if names[minId][2].to_ascii()[0] > names[j][2].to_ascii()[0]:
						minId = j
					elif names[minId][2].to_ascii()[0] == names[j][2].to_ascii()[0]:
						if names[minId][3].to_ascii()[0] > names[j][3].to_ascii()[0]:
							minId = j
		swap(i, minId, names)
		swap(i, minId, planetIndexArr)
	print(names)
	var size = hBoxContainer.get_child_count()
	for i in range(names.size()):
		hBoxContainer.remove_child(panelContainers[i])
	for i in range(names.size()):
		hBoxContainer.add_child(panelContainers[planetIndexArr[i]])
	pass

func tweenIt(time, color1, color2):
	var tween = self.get_node("ScrollContainer/Tween")
	tween.remove_all()
	tween.interpolate_property(hBoxContainer.get_parent(), "modulate",
			color1, color2, time/4,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(hBoxContainer.get_parent(), "modulate",
			color2, color1, time,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	pass

func swap(a,b, arr):
	var temp = arr[a]
	arr[a] = arr[b]
	arr[b] = temp
	pass

func searchAndAddTextPlanet(text):
	get_child(2).items[2].set_text(text)
	searchPlanet(text)
	pass

var matchingPlanets: = 0
func searchPlanet(text):
	var names = []
	for name in nameDic:
		names.append(name)

	var nonMatchingNames = []
	for name in names:
		if !name.matchn(text + "*"):
			 nonMatchingNames.append(name)

	for panel in panelContainers:
		if nonMatchingNames.has(panel.get_child(0).get_child(0).get_child(0).get_child(0).name):
			
			panel.visible = false
		else:
			matchingPlanets += 1
			panel.visible = true
#			viewP.set_h_size_flags(0) #Expand horizontal
#			viewP.set_v_size_flags(0)
	print(matchingPlanets)
	if matchingPlanets < 5:
		hBoxContainer.columns = matchingPlanets
	else:
		hBoxContainer.columns = 4
		matchingPlanets = 0
	pass

func sortByLastEdited():
	tweenIt(2.0, Color.white, Color.black)
	var indexArray = []
	print(planetsInScene.modifiedPlanets)
	var modifiedOrder = []
	for i in range(planetsInScene.modifiedPlanets.size()):
		modifiedOrder.append(planetsInScene.modifiedPlanets[i].name)
#	modifiedOrder.invert()
	print(modifiedOrder)
	for i in range(hBoxContainer.get_child_count()):
		var childPlanet = hBoxContainer.get_child(i).get_child(0).get_child(0).get_child(0).get_child(0)
		if not modifiedOrder.has(childPlanet.name):
			modifiedOrder.append(childPlanet.name)

	for i in range(panelContainers.size()):
		hBoxContainer.remove_child(panelContainers[i])
		
	for i in range(modifiedOrder.size()):
		for j in range(panelContainers.size()):
			var childPlanet = panelContainers[j].get_child(0).get_child(0).get_child(0).get_child(0)
			if modifiedOrder[i] == childPlanet.name:
				hBoxContainer.add_child(panelContainers[j])

	pass

func sortBySize():
	tweenIt(2.0, Color.white, Color.black)
	var planetIndexArr 	= []
	var planetIndex 	= 0
	var sizes 			= []
	var minId
	for size in sizeDic:
		sizes.append(size)
		planetIndexArr.append(planetIndex)
		planetIndex += 1

	for i in range(sizes.size()):
		minId = i
		for j in range(i+1, sizes.size()):
			if sizes[minId] < sizes[j]:
				minId = j


		swap(i, minId, sizes)
		swap(i, minId, planetIndexArr)
		
	var size = hBoxContainer.get_child_count()
	for i in range(sizes.size()):
		hBoxContainer.remove_child(panelContainers[i])
	for i in range(sizes.size()):
		hBoxContainer.add_child(panelContainers[planetIndexArr[i]])
	pass

func getPlanetsInScene():
	return 	get_parent().get_child(0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LineEdit_text_entered(new_text):
	namePanel.visible = false
	var tempNameDic = {}
	for vp in viewPorts:
		var planet = vp.get_child(0)
		
		if planet.name == selectedPlanet.name:
			for i in range(planetsInScene.get_child_count()):
				if planetsInScene.get_child(i).name == selectedPlanet.name:
					planetsInScene.get_child(i).name = new_text
			nameDic.erase(selectedPlanet.name)
			selectedPlanet.name = new_text

			tempNameDic[selectedPlanet.name] = selectedPlanet
			planet.get_parent().get_parent().get_parent().get_node("nameLabel").text = "Name: " + new_text
		tempNameDic[planet.name ] = planet
	nameDic = tempNameDic
	nameEdit.clear()

	selectedPlanet = null
	pass # Replace with function body.

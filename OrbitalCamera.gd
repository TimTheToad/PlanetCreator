extends Spatial


var target
# Called when the node enters the scene tree for the first time.

func setTarget(target):
	self.target = target

func _process(delta):
	
	if target:
		self.global_transform.origin = target.global_transform.origin
	
	pass

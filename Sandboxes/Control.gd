extends Control

var vis := true

func _input(event):
	
	if event is InputEventKey and event.is_pressed():
		if event.scancode  == KEY_H:
			vis = !vis
			self.visible = vis

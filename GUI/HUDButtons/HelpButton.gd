extends Button

var panel
var richText
var filePath = "res://HelperEntities/KursText/help.txt"

func _ready():
	panel = Panel.new()
	richText = RichTextLabel.new()
	richText.anchor_right = 1.0
	richText.anchor_bottom = 1.0
	
	var margin = 10
	richText.margin_left = margin
	richText.margin_top = margin
	richText.margin_right = -margin
	richText.margin_bottom = -margin
	
	panel.rect_size = Vector2(300, 200)
	panel.rect_position = Vector2(0, self.rect_size.y)
	
	panel.add_child(richText)
	self.add_child(panel)
	
	var content = loadFile(filePath)

	richText.bbcode_enabled = true
	richText.bbcode_text = content
	panel.visible = false

var checkTime = 1.0
var timer = 0
var modifiedTime
func _process(delta):
	if false:
		timer += delta
		if timer >= checkTime:
			var file = File.new()
			var mTime = file.get_modified_time(filePath)
			if mTime != modifiedTime:
				richText.bbcode_text = loadFile(filePath)
				modifiedTime = mTime
			

func loadFile(name):
	var file = File.new()
	file.open(name, File.READ)
	var content = file.get_as_text()
	file.close()
	return content

func _on_HelpButton_toggled(button_pressed):
	panel.visible = button_pressed
	pass # Replace with function body.

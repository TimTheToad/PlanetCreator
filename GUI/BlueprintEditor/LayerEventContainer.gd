extends ScrollContainer

var empty

onready var container = get_node("VBoxContainer")

func _ready():
#	empty = Control.new()
#	empty.rect_min_size = Vector2(104, 14)
#	container.add_child(empty)
#	empty.visible = false
	pass
	
func can_drop_data(position, event):
	# Check position if it is relevant to you
	# Otherwise, just check data
#	empty.visible = true
#	var index = container.get_children().find(event)
#	container.move_child(empty, index)
	
	
#	empty.rect_min_size = self.rect_size
#	container.add_child(empty)
#	container.move_child(empty, index)
	
	print("Dropped at: ", position)
	return typeof(event) == TYPE_DICTIONARY and event.has("expected")

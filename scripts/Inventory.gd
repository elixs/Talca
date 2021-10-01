extends GridContainer


var grabbed_item: Node2D = null setget set_grabbed_item
func set_grabbed_item(value):
	grabbed_item = value
	grabbed_item.scale = rect_scale

var Item = preload("res://scenes/Item.tscn")

func _ready() -> void:
	
	var inventory_file = File.new()
	inventory_file.open("res://data/inventory.json", File.READ)
	var inventory_dict: Dictionary = JSON.parse(inventory_file.get_as_text()).result

	for child_index in get_child_count():
		var slot = get_child(child_index) as Slot
		if slot:
			slot.connect("selected", self, "on_slot_selected", [slot])
			if inventory_dict.has(str(child_index)):
				var item = Item.instance()
				item.data = inventory_dict[str(child_index)]
				slot.item = item

func on_slot_selected(item: Node2D, slot: Slot):
	var canvas_layer = get_parent() as CanvasLayer
	if not canvas_layer:
		return
	if grabbed_item:
		if item:
			var temp_item = item
			slot.item = grabbed_item
			self.grabbed_item = temp_item
			grabbed_item.get_parent().remove_child(grabbed_item)
			canvas_layer.add_child(item)
		else:
			slot.item = grabbed_item
			grabbed_item = null
	else:
		if item:
			slot.item = null
			self.grabbed_item = item
			item.get_parent().remove_child(item)
			canvas_layer.add_child(item)



func _process(delta: float) -> void:
	if grabbed_item:
		grabbed_item.global_position = get_global_mouse_position()

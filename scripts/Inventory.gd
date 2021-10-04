extends GridContainer


var grabbed_item: Node2D = null setget _set_grabbed_item

var Item = preload("res://scenes/Item.tscn")

func _ready() -> void:
	hide()
	var items_file = File.new()
	items_file.open("res://data/items.json", File.READ)
	InventoryManager.data = JSON.parse(items_file.get_as_text()).result
	items_file.close()
	
	var inventory_file = File.new()
	inventory_file.open("res://data/inventory.json", File.READ)
	var inventory_dict: Dictionary = JSON.parse(inventory_file.get_as_text()).result
	inventory_file.close()

	for child_index in get_child_count():
		var slot = get_child(child_index) as Slot
		if slot:
			slot.connect("selected", self, "_on_slot_selected", [slot])
			if inventory_dict.has(str(child_index)):
				var item = Item.instance()
				var data = inventory_dict[str(child_index)]
				item.id = data["id"]
				item.quantity = data["quantity"]
				slot.item = item


func _process(delta: float) -> void:
	if grabbed_item:
		grabbed_item.global_position = get_global_mouse_position()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory") and not event.is_echo():
		get_tree().paused = !get_tree().paused
		visible = !visible


func _on_slot_selected(slot: Slot):
	if grabbed_item:
		if slot.item:
			# Check if the item are the same
			if InventoryManager.data.has(slot.item.id) and slot.item.id == grabbed_item.id:
				var total_quantity = slot.item.quantity + grabbed_item.quantity
				var stack_size = InventoryManager.data[slot.item.id]["stack_size"]
				if total_quantity < stack_size:
					slot.item.quantity = total_quantity 
					grabbed_item.queue_free()
					grabbed_item = null
				else:
					slot.item.quantity = stack_size 
					grabbed_item.quantity = total_quantity - stack_size
			else:
				# Swap items
				var temp_item = slot.item
				slot.item = grabbed_item
				self.grabbed_item = temp_item
		else:
			# Grabbed item to slot
			slot.item = grabbed_item
			self.grabbed_item = null
	elif slot.item:
		# Grab item from slot
		self.grabbed_item = slot.item
		slot.item = null


func _set_grabbed_item(item: Node2D):
	if item:
		item.get_parent().remove_child(item)
	grabbed_item = item
	if grabbed_item:
		get_parent().add_child(grabbed_item)
	

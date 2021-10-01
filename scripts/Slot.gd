class_name Slot

extends TextureRect


const EMPTY = Rect2(710, 662, 72, 72)
const FULL = Rect2(962, 662, 72, 72)

onready var holder = $Holder

signal selected

var item: Node2D = null setget set_item
func set_item(value):
	item = value
	if item:
		texture.region = FULL
		if item.get_parent():
			item.get_parent().remove_child(item)
		item.position = Vector2.ZERO
		holder.add_child(item)
	else:
		texture.region = EMPTY

func _ready() -> void:
	connect("gui_input", self, "_on_gui_input")

func _on_gui_input(event: InputEvent):
	if event.is_action_pressed("inventory_select") and not event.is_echo():
		emit_signal("selected", item)
